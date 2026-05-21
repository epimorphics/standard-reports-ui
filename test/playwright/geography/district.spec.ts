import { test, expect } from '@playwright/test'
import { clickNext, stepProgress, urls } from '../helpers'

test.describe('Geographical — district — steps 2–4', () => {
  test('select district and advance to step 3', async ({ page }) => {
    await page.goto(urls.atStep2)
    await page.locator('input[name="areaType"][value="district"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
  })

  test('step 3 — the user can input text and see matching locations in a dropdown menu', async ({ page }) => {
    await page.goto(urls.atStep2District)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
    const input = page.locator('input[name="area"]')
    await input.fill('south')
    await expect(page.locator('.ui-autocomplete')).toBeVisible()
    await expect(page.locator('.ui-menu-item').first()).toBeVisible()
  })

  test('step 3 — input Southwark and advance to step 4', async ({ page }) => {
    await page.goto(urls.atStep2District)
    await page.locator('input[name="area"]').fill('Southwark')
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 4 of 7')
  })

  test('step 4 — the only option is prefilled for Don\'t aggregate', async ({ page }) => {
    await page.goto(urls.atStep2District)
    await page.locator('input[name="area"]').fill('Southwark')
    await clickNext(page)
    const radios = page.locator('input[name="aggregate"]')
    await expect(radios).toHaveCount(1)
    await expect(radios.first()).toBeChecked()
    await expect(page.locator('label:has(input[name="aggregate"])')).toContainText('Don\'t aggregate')
  })

  test('advance from step 4 to step 5', async ({ page }) => {
    await page.goto(urls.atStep2District)
    await page.locator('input[name="area"]').fill('Southwark')
    await clickNext(page)
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 5 of 7')
  })
})
