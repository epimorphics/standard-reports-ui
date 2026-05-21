import { test, expect } from '@playwright/test'
import { clickNext, stepProgress, urls } from './helpers'

test.describe('Summary display — step 7', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(urls.atStep6Country)
  })

  test('the user is currently viewing step 7 of 7', async ({ page }) => {
    await expect(stepProgress(page)).toContainText('Step 7 of 7')
  })

  test('the user can read the parameters chosen in previous steps', async ({ page }) => {
    await expect(page.locator('.c-review-report')).toBeVisible()
    await expect(page.locator('.c-review-report li')).toHaveCount(6)
    await expect(page.locator('.c-review-report')).toContainText('average prices and volumes')
    await expect(page.locator('.c-review-report')).toContainText('England and Wales')
  })

  test('clicking change adjacent to report type routes back to step 1', async ({ page }) => {
    const reportTypeLi = page.locator('.c-review-report li').filter({
      hasText: 'average prices and volumes',
    })
    await reportTypeLi.getByRole('link', { name: 'change' }).click()
    await expect(stepProgress(page)).toContainText('Step 1 of 7')
  })

  test('changing report type and clicking next routes back to step 7', async ({ page }) => {
    const reportTypeLi = page.locator('.c-review-report li').filter({
      hasText: 'average prices and volumes',
    })
    await reportTypeLi.getByRole('link', { name: 'change' }).click()
    await expect(stepProgress(page)).toContainText('Step 1 of 7')
    await page.locator('input[name="report"][value="banded"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 7 of 7')
  })
})
