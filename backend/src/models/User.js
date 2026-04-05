const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    monthlyIncome: {
      type: Number,
      required: true,
      min: [1, "Monthly income must be greater than 0"]
    },
    monthlyBudget: {
      type: Number,
      default: null,
      min: [0, "Monthly budget cannot be negative"]
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("User", userSchema);
