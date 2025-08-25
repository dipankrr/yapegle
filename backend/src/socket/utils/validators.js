export function isNonEmptyString(x, max = 2000) {
  return typeof x === 'string' && x.trim().length > 0 && x.length <= max;
}

export const isJson = (v) => {
  if (typeof v === 'object' && v !== null) return true;
  if (typeof v !== 'string') return false;
  try { JSON.parse(v); return true; } catch { return false; }
};