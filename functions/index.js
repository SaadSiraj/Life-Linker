const { onCall, HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const {
    RekognitionClient,
    IndexFacesCommand,
    SearchFacesByImageCommand,
    DeleteFacesCommand,
    ListFacesCommand,
} = require("@aws-sdk/client-rekognition");
const fetch = require("node-fetch");

admin.initializeApp();

const COLLECTION_ID = "lifelinker-faces";

function getRekognitionClient() {
    return new RekognitionClient({
        region: "us-east-1",
        credentials: {
            accessKeyId: process.env.AWS_ACCESS_KEY,
            secretAccessKey: process.env.AWS_SECRET_KEY,
        },
    });
}

// ── indexFace (RENAMED from indexUserFace — old function was stale/conflicted) ──
exports.indexFace = onCall(async (request) => {
    console.log("[indexFace] UID:", request.auth ? request.auth.uid : "NULL — NO AUTH");

    if (!request.auth) {
        console.error("[indexFace] UNAUTHENTICATED");
        throw new HttpsError("unauthenticated", "Login required");
    }

    const { userId, imageUrl } = request.data;
    console.log("[indexFace] userId:", userId);
    console.log("[indexFace] imageUrl:", imageUrl ? imageUrl.substring(0, 80) : "NULL");

    if (!userId || !imageUrl) {
        throw new HttpsError("invalid-argument", "userId and imageUrl required");
    }

    const rekognition = getRekognitionClient();

    try {
        const response = await fetch(imageUrl);
        if (!response.ok) {
            throw new HttpsError("internal", "Image download failed: " + response.status);
        }
        const buffer = await response.buffer();
        console.log("[indexFace] Image size:", buffer.length, "bytes");

        await _deleteFacesForUser(rekognition, userId);

        const result = await rekognition.send(new IndexFacesCommand({
            CollectionId: COLLECTION_ID,
            Image: { Bytes: buffer },
            ExternalImageId: userId,
            DetectionAttributes: [],
            MaxFaces: 1,
            QualityFilter: "AUTO",
        }));

        console.log("[indexFace] FaceRecords:", result.FaceRecords ? result.FaceRecords.length : 0);

        if (result.UnindexedFaces && result.UnindexedFaces.length > 0) {
            result.UnindexedFaces.forEach((f) => {
                console.warn("[indexFace] Unindexed reason:", f.Reasons ? f.Reasons.join(", ") : "unknown");
            });
        }

        if (!result.FaceRecords || result.FaceRecords.length === 0) {
            throw new HttpsError("not-found", "No face detected in profile image");
        }

        const faceId = result.FaceRecords[0].Face.FaceId;
        const confidence = result.FaceRecords[0].Face.Confidence;
        console.log("[indexFace] SUCCESS faceId:", faceId, "confidence:", confidence);

        await admin.firestore().collection("users").doc(userId).update({
            awsFaceId: faceId,
            faceIndexed: true,
        });

        return { success: true, faceId, confidence };
    } catch (error) {
        console.error("[indexFace] Error:", error.name, error.message);
        if (error instanceof HttpsError) throw error;
        throw new HttpsError("internal", error.message);
    }
});

// ── matchFace ────────────────────────────────────────────────────────────────
exports.matchFace = onCall(async (request) => {
    console.log("[matchFace] UID:", request.auth ? request.auth.uid : "NULL");

    if (!request.auth) {
        throw new HttpsError("unauthenticated", "Login required");
    }

    const { imageBase64 } = request.data;
    if (!imageBase64) {
        throw new HttpsError("invalid-argument", "imageBase64 required");
    }

    const imageBuffer = Buffer.from(imageBase64, "base64");
    console.log("[matchFace] Buffer size:", imageBuffer.length, "bytes");

    const rekognition = getRekognitionClient();

    try {
        const result = await rekognition.send(new SearchFacesByImageCommand({
            CollectionId: COLLECTION_ID,
            Image: { Bytes: imageBuffer },
            MaxFaces: 1,
            FaceMatchThreshold: 60,
            QualityFilter: "AUTO",
        }));

        console.log("[matchFace] FaceMatches:", result.FaceMatches ? result.FaceMatches.length : 0);

        if (!result.FaceMatches || result.FaceMatches.length === 0) {
            return { matched: false, noFace: false };
        }

        const bestMatch = result.FaceMatches[0];
        const userId = bestMatch.Face.ExternalImageId;
        const confidence = bestMatch.Similarity;
        console.log("[matchFace] Match userId:", userId, "confidence:", confidence);

        const userDoc = await admin.firestore().collection("users").doc(userId).get();
        if (!userDoc.exists) {
            return { matched: false, noFace: false };
        }

        const userData = userDoc.data();
        return {
            matched: true,
            noFace: false,
            userId,
            userName: userData.name || "Unknown",
            confidence: Math.round(confidence * 10) / 10,
        };
    } catch (error) {
        console.error("[matchFace] Error:", error.name, error.message);
        if (
            error.name === "InvalidParameterException" ||
            (error.message && error.message.toLowerCase().includes("no faces"))
        ) {
            return { matched: false, noFace: true };
        }
        throw new HttpsError("internal", error.message);
    }
});

// ── debugCollectionStatus ────────────────────────────────────────────────────
exports.debugCollectionStatus = onCall(async (request) => {
    console.log("[debugCollection] Called by:", request.auth ? request.auth.uid : "NULL");
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "Login required");
    }

    const rekognition = getRekognitionClient();

    try {
        const listResult = await rekognition.send(new ListFacesCommand({
            CollectionId: COLLECTION_ID,
            MaxResults: 100,
        }));

        const faces = (listResult.Faces || []).map((f) => ({
            faceId: f.FaceId,
            userId: f.ExternalImageId,
        }));
        console.log("[debugCollection] AWS faces:", faces.length);
        faces.forEach((f) => console.log("  userId:", f.userId));

        const snap = await admin.firestore().collection("users").get();
        const notIndexed = [];
        const indexed = [];
        snap.docs.forEach((doc) => {
            const data = doc.data();
            if (data.profileImageUrl) {
                if (data.faceIndexed === true) indexed.push({ id: doc.id, name: data.name });
                else notIndexed.push({ id: doc.id, name: data.name });
            }
        });

        return { awsFaceCount: faces.length, awsFaces: faces, firestoreIndexed: indexed, firestoreNotIndexed: notIndexed };
    } catch (error) {
        console.error("[debugCollection] Error:", error.name, error.message);
        if (error.name === "ResourceNotFoundException") {
            return { error: "COLLECTION_NOT_FOUND", message: "Collection does not exist: " + COLLECTION_ID };
        }
        throw new HttpsError("internal", error.message);
    }
});

// ── deleteUserFace ───────────────────────────────────────────────────────────
exports.deleteUserFace = onCall(async (request) => {
    if (!request.auth) throw new HttpsError("unauthenticated", "Login required");
    const { userId } = request.data;
    const rekognition = getRekognitionClient();
    await _deleteFacesForUser(rekognition, userId);
    return { success: true };
});

// ── Helper ───────────────────────────────────────────────────────────────────
async function _deleteFacesForUser(rekognition, userId) {
    try {
        const facesToDelete = [];
        let nextToken = undefined;
        do {
            const listResult = await rekognition.send(new ListFacesCommand({
                CollectionId: COLLECTION_ID,
                MaxResults: 100,
                NextToken: nextToken,
            }));
            (listResult.Faces || [])
                .filter((f) => f.ExternalImageId === userId)
                .forEach((f) => facesToDelete.push(f.FaceId));
            nextToken = listResult.NextToken;
        } while (nextToken);

        if (facesToDelete.length === 0) return;
        await rekognition.send(new DeleteFacesCommand({ CollectionId: COLLECTION_ID, FaceIds: facesToDelete }));
        console.log("[_deleteFaces] Deleted", facesToDelete.length, "faces for", userId);
    } catch (error) {
        console.error("[_deleteFaces] Error:", error.name, error.message);
    }
}