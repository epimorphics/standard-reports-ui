import { test, expect } from '@playwright/test'
import { clickNext, nextBtn, stepProgress, urls } from './helpers'

test.describe('Select a report type — step 1', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('')
    await page.getByRole('link', { name: 'create a standard report' }).click()
  })

  test('the user is currently viewing step 1 of 7', async ({ page }) => {
    await expect(stepProgress(page)).toContainText('Step 1 of 7')
  })

  test('user can access report tool via landing page link', async ({ page }) => {
    await expect(page.locator('.select-report')).toBeVisible()
  })

  test('a user can click to view expanded sections of the page', async ({ page }) => {
    const summary = page.locator('summary#average-prices-report')
    await summary.click()
    await expect(page.locator('details:has(#average-prices-report)')).toHaveAttribute('open', '')
  })

  test('a user can select radio inputs', async ({ page }) => {
    await page.locator('input[name="report"][value="avgPrice"]').check()
    await expect(page.locator('input[name="report"][value="avgPrice"]')).toBeChecked()
  })

  test('a user cannot progress until a selection is made', async ({ page }) => {
    await nextBtn(page).click()
    await expect(stepProgress(page)).toContainText('Step 1 of 7')
  })

  test('select Average prices and volumes and advance to step 2', async ({ page }) => {
    await page.locator('input[name="report"][value="avgPrice"]').check()
    await expect(page.locator('input[name="report"][value="avgPrice"]')).toBeChecked()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 2 of 7')
  })

  test('navigating directly to step 2 state shows step 2', async ({ page }) => {
    await page.goto(urls.atStep2)
    await expect(stepProgress(page)).toContainText('Step 2 of 7')
  })
})
