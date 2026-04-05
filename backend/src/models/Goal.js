const mongoose = require("mongoose");

const goalSchema = new mongoose.Schema(
  {
    goalName: {
      type: String,
      required: [true, "Goal name is required"],
      trim: true
    },
    targetAmount: {
      type: Number,
      required: [true, "Target amount is required"],
      min: [1, "Target amount must be greater than 0"]
    },
    targetDate: {
      type: Date,
      required: [true, "Target date is required"]
    },
    savedAmount: {
      type: Number,
      default: 0,
      min: [0, "Saved amount cannot be negative"]
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Goal", goalSchema);
