import { test, expect } from '@playwright/test'

test.describe('Landing page', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('')
  })

  test('user can read description of report application', async ({ page }) => {
    await expect(page.locator('h1')).toContainText('Price Paid Data')
    await expect(page.locator('body')).toContainText('standard reports application')
  })

  test('user can access link to report building tool', async ({ page }) => {
    const link = page.getByRole('link', { name: 'create a standard report' })
    await expect(link).toBeVisible()
    await link.click()
    await expect(page).toHaveURL(/report-design/)
  })
})
