import { defineConfig } from '@prisma/config';

export default defineConfig({
  engine: 'classic',
  datasource: {
    // Absolutní cesta uvnitř Dockeru
    url: 'file:/app/prisma/dev.db',
  },
});