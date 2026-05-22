import { test, expect } from '@playwright/test'
import { clickNext, stepProgress, urls } from '../helpers'

test.describe('Geographical — region — steps 2–4', () => {
  test('select region and advance to step 3', async ({ page }) => {
    await page.goto(urls.atStep2)
    await page.locator('input[name="areaType"][value="region"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
  })

  test('step 3 — the user can select a region from a list of options', async ({ page }) => {
    await page.goto(urls.atStep2Region)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
    await expect(page.locator('input[name="area"]').first()).toBeVisible()
    await expect(page.locator('label:has(input[name="area"])')).toHaveCount(10)
  })

  test('step 3 — the user can select a region from a map view', async ({ page }) => {
    await page.goto(urls.atStep2Region)
    await expect(page.locator('#map')).toBeVisible()
  })

  test('step 3 — the user can zoom in and out of the map', async ({ page }) => {
    await page.goto(urls.atStep2Region)
    await expect(page.locator('.leaflet-control-zoom-in')).toBeVisible()
    await expect(page.locator('.leaflet-control-zoom-out')).toBeVisible()
    await page.locator('.leaflet-control-zoom-in').click()
    await page.locator('.leaflet-control-zoom-out').click()
  })

  test('step 3 — hovering over a highlighted map area displays the region name', async ({ page }) => {
    await page.goto(urls.atStep2Region)
    const map = page.locator('#map')
    await page.locator('.leaflet-interactive').first().waitFor()
    const box = await map.boundingBox()
    // eslint-disable-next-line playwright/no-conditional-in-test
    if (!box) throw new Error('Map element has no bounding box')
    await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2)
    await expect(page.locator('.leaflet-popup-content')).toBeVisible()
  })

  test('step 3 — clicking a highlighted map area selects that option from the list', async ({ page }) => {
    await page.goto(urls.atStep2Region)
    await page.locator('.leaflet-interactive').first().waitFor()
    await page.locator('.leaflet-interactive').first().click()
    await expect(page.locator('input[name="area"]:checked')).toHaveCount(1)
  })

  test('advance from step 3 to step 4', async ({ page }) => {
    await page.goto(urls.atStep2Region)
    await page.locator('input[name="area"]').first().check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 4 of 7')
  })

  test('step 4 — the user can see 6 options for location specification', async ({ page }) => {
    await page.goto(urls.atStep2Region)
    await page.locator('input[name="area"]').first().check()
    await clickNext(page)
    await expect(page.locator('input[name="aggregate"]')).toHaveCount(6)
  })

  test('select Don\'t aggregate and advance to step 5', async ({ page }) => {
    await page.goto(urls.atStep2Region)
    await page.locator('input[name="area"]').first().check()
    await clickNext(page)
    await page.locator('input[name="aggregate"][value="none"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 5 of 7')
  })
})
