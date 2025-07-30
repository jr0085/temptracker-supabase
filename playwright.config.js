module.exports = {
  testDir: './tests',
  timeout: 30000,
  use: {
    screenshot: 'only-on-failure',
    trace: 'retain-on-failure',
  },
  projects: [
    {
      name: 'Desktop',
      use: {
        viewport: { width: 1280, height: 720 },
      },
    },
    {
      name: 'Mobile',
      use: {
        viewport: { width: 375, height: 667 },
        isMobile: true,
        hasTouch: true,
      },
    },
  ],
};