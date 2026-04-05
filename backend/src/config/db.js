const mongoose = require("mongoose");

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("database connected");
  } catch (error) {
    console.error("database connection failed:", error.message);
    throw error;
  }
};

mongoose.connection.on("error", (error) => {
  console.error("database connection failed:", error.message);
});

mongoose.connection.on("disconnected", () => {
  console.warn("database disconnected");
});

module.exports = connectDB;
