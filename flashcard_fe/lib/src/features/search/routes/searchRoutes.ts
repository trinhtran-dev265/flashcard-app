import express from "express";
import * as searchController from "../controllers/search.js";
import {
  searchPetSchema,
  searchProductSchema,
} from "../validators/searchValidate.js";
import { validateBody } from "../middlewares/joiValidationMiddleware.js";
const router = express.Router();

router.get("/pet", validateBody(searchPetSchema), searchController.searchPet);
router.get(
  "/product",
  validateBody(searchProductSchema),
  searchController.searchProduct,
);

export default router;
