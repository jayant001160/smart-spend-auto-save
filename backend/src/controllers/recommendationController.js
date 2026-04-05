const { getWeeklyAutoSaveRecommendation } = require("../services/recommendationService");

const getRecommendation = async (req, res, next) => {
  try {
    const recommendation = await getWeeklyAutoSaveRecommendation();
    return res.status(200).json({
      success: true,
      data: recommendation
    });
  } catch (error) {
    return next(error);
  }
};

module.exports = {
  getRecommendation
};
