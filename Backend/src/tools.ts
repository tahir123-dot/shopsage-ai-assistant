const BASE_URL = "https://dummyjson.com/products";

export type Product = {
  id: number;
  title: string;
  price: number;
  category: string;
  thumbnail: string;
};

// DummyJSON ka poora product chhota karke sirf zaroori cheezein
function slim(p: any): Product {
  return {
    id: p.id,
    title: p.title,
    price: p.price,
    category: p.category,
    thumbnail: p.thumbnail,
  };
}

export async function searchProducts(query: string, limit = 5): Promise<Product[]> {
  const res = await fetch(`${BASE_URL}/search?q=${encodeURIComponent(query)}&limit=${limit}`);
  const data: any = await res.json();
  return data.products.map(slim);
}

export async function getProductsByCategory(category: string, limit = 5): Promise<Product[]> {
  const res = await fetch(`${BASE_URL}/category/${encodeURIComponent(category)}?limit=${limit}`);
  const data: any = await res.json();
  return data.products.map(slim);
}

export async function getCategories(): Promise<string[]> {
  const res = await fetch(`${BASE_URL}/category-list`);
  return (await res.json()) as string[];
}