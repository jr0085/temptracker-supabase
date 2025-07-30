// Simple Playwright test using global installation
const assert = require('assert');
const path = require('path');

// Try to use global playwright installation
let chromium;
try {
  // Try global installation path
  chromium = require('C:/Users/jr008/AppData/Roaming/npm/node_modules/playwright').chromium;
} catch (e) {
  try {
    // Fallback to regular require
    chromium = require('playwright').chromium;
  } catch (e2) {
    console.error('❌ Playwright not found. Please ensure Playwright is installed globally.');
    process.exit(1);
  }
}

const htmlFile = `file://${path.resolve('index.html')}`;

(async () => {
  console.log('🧪 Starting TempTracker Pro v1.10.61 Tests...');
  
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  
  try {
    // Test 1: Load page and check version
    console.log('📋 Test 1: Loading page and checking version...');
    await page.goto(htmlFile);
    await page.waitForLoadState('networkidle');
    
    const title = await page.title();
    assert(title.includes('v1.10.61'), `Title should contain v1.10.61, got: ${title}`);
    console.log('✅ Version test passed!');
    
    // Test 2: Check PWA meta tags
    console.log('📋 Test 2: Checking PWA meta tags...');
    
    const appleMeta = await page.getAttribute('meta[name="apple-mobile-web-app-capable"]', 'content');
    assert(appleMeta === 'yes', `Apple PWA meta should be 'yes', got: ${appleMeta}`);
    
    const mobileMeta = await page.getAttribute('meta[name="mobile-web-app-capable"]', 'content');
    assert(mobileMeta === 'yes', `Mobile PWA meta should be 'yes', got: ${mobileMeta}`);
    
    const themeMeta = await page.getAttribute('meta[name="theme-color"]', 'content');
    assert(themeMeta === '#059669', `Theme color should be '#059669', got: ${themeMeta}`);
    
    console.log('✅ PWA meta tags test passed!');
    
    // Test 3: Check viewport meta tag
    console.log('📋 Test 3: Checking viewport meta tag...');
    
    const viewportMeta = await page.getAttribute('meta[name="viewport"]', 'content');
    assert(viewportMeta === 'width=device-width, initial-scale=1.0', 
           `Viewport should be 'width=device-width, initial-scale=1.0', got: ${viewportMeta}`);
    
    console.log('✅ Viewport meta tag test passed!');
    
    // Test 4: Mobile viewport test
    console.log('📋 Test 4: Testing mobile viewport...');
    
    await page.setViewportSize({ width: 375, height: 667 });
    await page.reload();
    await page.waitForLoadState('networkidle');
    
    // Check if page is responsive on mobile size
    const bodyWidth = await page.evaluate(() => document.body.offsetWidth);
    assert(bodyWidth <= 375, `Body width should fit mobile viewport, got: ${bodyWidth}`);
    
    console.log('✅ Mobile viewport test passed!');
    
    console.log('🎉 All TempTracker Pro v1.10.61 tests passed!');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();