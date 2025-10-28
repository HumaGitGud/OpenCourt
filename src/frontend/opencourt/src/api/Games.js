const BASE = import.meta.env.VITE_SERVER_BASE_URL ?? (import.meta.env.VITE_SERVER_HOST ? `http://${import.meta.env.VITE_SERVER_HOST}:${import.meta.env.VITE_SERVER_PORT}` : "");

export async function getGames() {
  const res = await fetch(`${BASE}/games`);
  if (!res.ok) throw new Error("Failed to fetch games");
  return res.json();
}

export async function createGame(gameData) {
  const res = await fetch(`${BASE}/games`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(gameData),
  });

  if (!res.ok) throw new Error("Failed to create game.");
  return res.json();
}