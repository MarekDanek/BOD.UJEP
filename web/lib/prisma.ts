import { PrismaClient } from '@prisma/client'

// Tohle zabrání Next.js, aby při každém uložení (F5) vytvářel nová a prázdná připojení
const globalForPrisma = global as unknown as { prisma: PrismaClient }

export const prisma =
  globalForPrisma.prisma ||
  new PrismaClient() // Úplně čisté volání bez adaptérů!

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma