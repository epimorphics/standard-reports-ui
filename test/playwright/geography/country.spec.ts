import { test, expect } from '@playwright/test'
import { clickNext, nextBtn, stepProgress, urls } from '../helpers'

test.describe('Geographical — country — steps 2–4', () => {
  test('the user is currently viewing step 2 of 7', async ({ page }) => {
    await page.goto(urls.atStep2)
    await expect(stepProgress(page)).toContainText('Step 2 of 7')
  })

  test('a user cannot progress until a selection is made', async ({ page }) => {
    await page.goto(urls.atStep2)
    await nextBtn(page).click()
    await expect(stepProgress(page)).toContainText('Step 2 of 7')
  })

  test('select country and advance to step 3', async ({ page }) => {
    await page.goto(urls.atStep2)
    await page.locator('input[name="areaType"][value="country"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
  })

  test('step 3 — the only option is prefilled for England and Wales', async ({ page }) => {
    await page.goto(urls.atStep2Country)
    await expect(stepProgress(page)).toContainText('Step 3 of 7')
    const radios = page.locator('input[name="area"]')
    await expect(radios).toHaveCount(1)
    await expect(page.locator('label:has(input[name="area"])')).toContainText('England and Wales')
  })

  test('advance from step 3 to step 4', async ({ page }) => {
    await page.goto(urls.atStep2Country)
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 4 of 7')
  })

  test('step 4 — the user can see 6 options for location specification', async ({ page }) => {
    await page.goto(urls.atStep3Country)
    await expect(stepProgress(page)).toContainText('Step 4 of 7')
    await expect(page.locator('input[name="aggregate"]')).toHaveCount(6)
  })

  test('select Don\'t aggregate and advance to step 5', async ({ page }) => {
    await page.goto(urls.atStep3Country)
    await page.locator('input[name="aggregate"][value="none"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 5 of 7')
  })
})
