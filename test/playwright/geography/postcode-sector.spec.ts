import { test, expect } from '@playwright/test'
import { clickNext, stepProgress, urls } from '../helpers'

test.describe('Geographical — postcode sector — steps 2–4', () => {
  test('select postcode sector and advance to step 3', async ({ page }) => {
    await page.goto(urls.atStep2)
    await page.locator('input[name="areaType"][value="pcSector"]').check()
    await expect(page.locator('label:has(input[name="areaType"][value="pcSector"])')).toContainText('Postcode sector')
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
  })

  test('step 3 — the user can input text', async ({ page }) => {
    await page.goto(urls.atStep2PcSector)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
    const input = page.locator('input[name="area"]')
    await expect(input).toBeVisible()
    await input.fill('BS49 2')
    await expect(input).toHaveValue('BS49 2')
  })

  test('step 3 — input BS49 2 and advance to step 4', async ({ page }) => {
    await page.goto(urls.atStep2PcSector)
    await page.locator('input[name="area"]').fill('BS49 2')
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 4 of 7')
  })

  test('step 4 — the only option is prefilled for Don\'t aggregate', async ({ page }) => {
    await page.goto(urls.atStep2PcSector)
    await page.locator('input[name="area"]').fill('BS49 2')
    await clickNext(page)
    const radios = page.locator('input[name="aggregate"]')
    await expect(radios).toHaveCount(1)
    await expect(radios.first()).toBeChecked()
    await expect(page.locator('label:has(input[name="aggregate"])')).toContainText('Don\'t aggregate')
  })

  test('advance from step 4 to step 5', async ({ page }) => {
    await page.goto(urls.atStep2PcSector)
    await page.locator('input[name="area"]').fill('BS49 2')
    await clickNext(page)
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 5 of 7')
  })
})
