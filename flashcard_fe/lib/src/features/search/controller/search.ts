import type { Request, Response } from "express";
import * as Services from "../services/searchService.js";

export const searchPet = async (req: Request, res: Response) => {
  try {
    const { keyword = "" } = req.query as { keyword?: string };
    const pets = await Services.searchPet(keyword);
    return res.json({ data: pets });
  } catch (err: any) {
    return res
      .status(err.status ?? 500)
      .json({ message: err.message ?? "Internal server error!" });
  }
};

export const searchProduct = async (req: Request, res: Response) => {
  try {
    const { keyword = "" } = req.query as { keyword?: string };
    const userId = (req as any).user.id;

    const products = await Services.searchProduct(keyword, userId);
    return res.status(200).json({ data: products });
  } catch (err: any) {
    return res
      .status(err.status ?? 500)
      .json({ message: err.message ?? "Internal server error!" });
  }
};
