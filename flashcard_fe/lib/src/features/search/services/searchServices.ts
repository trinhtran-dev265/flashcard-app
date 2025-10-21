import * as Repo from "../repositories/searchRepo.js";

export async function searchPet(keyword: string) {
  return await Repo.searchPet(keyword);
}

export const searchProduct = async (keyword: string, userId: string) => {
  const pets = await Repo.getPetByUserId(userId);

  if (!pets.length) return [];

  const productTypeIds = pets.map((p) => p.productTypeID);
  return await Repo.searchProduct(keyword, productTypeIds);
};
