export function getBaseRepository(base: string): string {
    if (!base) return '/';
    const parts = base.split('/').filter(Boolean);
    return parts.length > 0 ? `/${parts[0]}/` : '/';
  }
  