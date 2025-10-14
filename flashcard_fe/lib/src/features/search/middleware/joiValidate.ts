import Joi from "joi";

export const searchPetSchema = Joi.object({
  keyword: Joi.string().min(1).required(),
});

export const searchProductSchema = Joi.object({
  keyword: Joi.string().min(1).required(),
  userId: Joi.string().uuid().required(),
});
