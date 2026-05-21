import { test, expect } from '@playwright/test'
import { clickNext, stepProgress, urls } from '../helpers'

test.describe('Geographical — postcode district — steps 2–4', () => {
  test('select postcode district and advance to step 3', async ({ page }) => {
    await page.goto(urls.atStep2)
    await page.locator('input[name="areaType"][value="pcDistrict"]').check()
    await expect(page.locator('label:has(input[name="areaType"][value="pcDistrict"])')).toContainText('Postcode district')
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
  })

  test('step 3 — the user can input text', async ({ page }) => {
    await page.goto(urls.atStep2PcDistrict)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
    const input = page.locator('input[name="area"]')
    await expect(input).toBeVisible()
    await input.fill('BS49')
    await expect(input).toHaveValue('BS49')
  })

  test('step 3 — input BS49 and advance to step 4', async ({ page }) => {
    await page.goto(urls.atStep2PcDistrict)
    await page.locator('input[name="area"]').fill('BS49')
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 4 of 7')
  })

  test('step 4 — the user can see 2 options for location specification', async ({ page }) => {
    await page.goto(urls.atStep2PcDistrict)
    await page.locator('input[name="area"]').fill('BS49')
    await clickNext(page)
    await expect(page.locator('input[name="aggregate"]')).toHaveCount(2)
  })

  test('select Don\'t aggregate and advance to step 5', async ({ page }) => {
    await page.goto(urls.atStep2PcDistrict)
    await page.locator('input[name="area"]').fill('BS49')
    await clickNext(page)
    await page.locator('input[name="aggregate"][value="none"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 5 of 7')
  })
})
