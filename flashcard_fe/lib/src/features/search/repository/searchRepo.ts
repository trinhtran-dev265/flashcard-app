import { pool } from "../configs/connectDB.js";
import type { User } from "../entities/User.js";

export async function searchPet(keyword: string) {
  const [rows] = await pool.execute<User[]>(
    `SELECT id, name, species, price, description
     FROM Pet
     WHERE name LIKE ? OR species LIKE ?`,
    [`%${keyword}%`, `%${keyword}%`],
  );
  return rows;
}

export const searchProduct = async (
  keyword: string,
  productTypeIds: string[],
) => {
  const [rows] = await pool.execute(
    `SELECT * FROM Products 
     WHERE (name LIKE ? OR description LIKE ?) 
     AND productTypeID IN (?)`,
    [`%${keyword}%`, ...productTypeIds],
  );
  return rows;
};

export const getPetByUserId = async (userId: string) => {
  const [rows] = await pool.execute(
    `SELECT p.id, p.name, p.productTypeID
     FROM Pets p
     INNER JOIN Orders o ON o.petId = p.id
     WHERE o.userId = ?`,
    [userId],
  );
  return rows as any[];
};
