export function isNonEmptyString(x, max = 2000) {
  return typeof x === 'string' && x.trim().length > 0 && x.length <= max;
}