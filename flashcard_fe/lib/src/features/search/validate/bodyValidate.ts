import type { Request, Response, NextFunction } from "express";
import type { ObjectSchema } from "joi";

export const validateBody =
  (schema: ObjectSchema) =>
  (req: Request, res: Response, next: NextFunction) => {
    const { error, value } = schema.validate(req.body, {
      abortEarly: false,
      allowUnknown: false,
      stripUnknown: true,
    });
    if (error) {
      const details = error.details.map((d) => d.message);
      return res.status(400).json({ errors: details });
    }
    req.body = value;
    next();
  };
