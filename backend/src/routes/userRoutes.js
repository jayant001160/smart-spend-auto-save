const express = require("express");
const { upsertUserProfile, getUserProfile } = require("../controllers/userController");

const router = express.Router();

router.post("/", upsertUserProfile);
router.get("/", getUserProfile);

module.exports = router;
