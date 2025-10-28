const BASE = import.meta.env.VITE_SERVER_BASE_URL ?? (import.meta.env.VITE_SERVER_HOST ? `http://${import.meta.env.VITE_SERVER_HOST}:${import.meta.env.VITE_SERVER_PORT}` : "");

export async function getUsers() {
  const res = await fetch(`${BASE}/users`);
  if (!res.ok) throw new Error("Failed to fetch events");
  return res.json();
}

export async function createUser(userData) {
  const res = await fetch(`${BASE}/users`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(userData),
  });

  if (!res.ok) throw new Error("Failed to create user.");
  return res.json();
}