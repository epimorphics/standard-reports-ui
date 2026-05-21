import { test, expect } from '@playwright/test'
import { clickNext, nextBtn, stepProgress, urls } from './helpers'

test.describe('Additional options — step 6', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(urls.atStep5Country)
  })

  test('the user is currently viewing step 6 of 7', async ({ page }) => {
    await expect(stepProgress(page)).toContainText('Step 6 of 7')
  })

  test('the user can select different property types', async ({ page }) => {
    await expect(page.locator('input[name="age"][value="any"]')).toBeVisible()
    await expect(page.locator('input[name="age"][value="new"]')).toBeVisible()
    await expect(page.locator('input[name="age"][value="old"]')).toBeVisible()
  })

  test('a user cannot progress until a selection is made', async ({ page }) => {
    await nextBtn(page).click()
    await expect(stepProgress(page)).toContainText('Step 6 of 7')
  })

  test('select Both old and new properties and advance to step 7', async ({ page }) => {
    await page.locator('input[name="age"][value="any"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 7 of 7')
  })
})
