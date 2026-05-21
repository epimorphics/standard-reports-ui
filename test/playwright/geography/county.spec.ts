import { test, expect } from '@playwright/test'
import { clickNext, stepProgress, urls } from '../helpers'

test.describe('Geographical — county — steps 2–4', () => {
  test('select county and advance to step 3', async ({ page }) => {
    await page.goto(urls.atStep2)
    await page.locator('input[name="areaType"][value="county"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
  })

  test('step 3 — the user can input text and see matching locations in a dropdown menu', async ({ page }) => {
    await page.goto(urls.atStep2County)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
    const input = page.locator('input[name="area"]')
    await input.fill('dev')
    await expect(page.locator('.ui-autocomplete')).toBeVisible()
    await expect(page.locator('.ui-menu-item').first()).toBeVisible()
  })

  test('step 3 — the user can select a location from a map view', async ({ page }) => {
    await page.goto(urls.atStep2County)
    await expect(page.locator('#map')).toBeVisible()
  })

  test('step 3 — the user can zoom in and out of the map', async ({ page }) => {
    await page.goto(urls.atStep2County)
    await expect(page.locator('.leaflet-control-zoom-in')).toBeVisible()
    await expect(page.locator('.leaflet-control-zoom-out')).toBeVisible()
    await page.locator('.leaflet-control-zoom-in').click()
    await page.locator('.leaflet-control-zoom-out').click()
  })

  test('step 3 — hovering over a highlighted area displays a location name', async ({ page }) => {
    await page.goto(urls.atStep2County)
    await page.waitForFunction(() => typeof (window as Window & { MapSearch?: unknown }).MapSearch !== 'undefined')
    const map = page.locator('#map')
    const box = await map.boundingBox()
    // eslint-disable-next-line playwright/no-conditional-in-test
    if (!box) throw new Error('Map element has no bounding box')
    await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2)
    await expect(page.locator('.leaflet-popup-content')).toBeVisible()
  })

  test('step 3 — clicking a highlighted map area prefills the input field', async ({ page }) => {
    await page.goto(urls.atStep2County)
    await page.waitForFunction(() => typeof (window as Window & { MapSearch?: unknown }).MapSearch !== 'undefined')
    await page.locator('.leaflet-interactive').first().waitFor()
    await page.locator('.leaflet-interactive').first().click()
    await expect(page.locator('input[name="area"]')).not.toHaveValue('')
  })

  test('step 4 — the user can see 5 options for location specification', async ({ page }) => {
    await page.goto(urls.atStep2County)
    await page.locator('input[name="area"]').fill('Devon')
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 4 of 7')
    await expect(page.locator('input[name="aggregate"]')).toHaveCount(5)
  })

  test('select Don\'t aggregate and advance to step 5', async ({ page }) => {
    await page.goto(urls.atStep2County)
    await page.locator('input[name="area"]').fill('Devon')
    await clickNext(page)
    await page.locator('input[name="aggregate"][value="none"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 5 of 7')
  })
})
