import { test, expect } from '@playwright/test'
import { clickNext, stepProgress, urls } from './helpers'

const currentYear = new Date().getFullYear()
const prevYear = currentYear - 1

test.describe('Report generation', () => {
  test('select multiple time periods and generate a report', async ({ page }) => {
    await page.goto(urls.atStep4Country)
    await expect(stepProgress(page)).toContainText('Step 5 of 7')

    // Select latest available options
    await page.locator('input[name="period[]"][value="ytd"]').check()
    await page.locator('input[name="period[]"][value="latest_q"]').check()
    await page.locator('input[name="period[]"][value="latest_m"]').check()

    // Select specific years — expand More dates first for older years
    await page.locator(`input[name="period[]"][value="${currentYear}"]`).check()
    await page.locator(`input[name="period[]"][value="${prevYear}"]`).check()

    await clickNext(page)

    // Step 6 — additional options
    await expect(stepProgress(page)).toContainText('Step 6 of 7')
    await page.locator('input[name="age"][value="any"]').check()
    await clickNext(page)

    // Step 7 — generate report
    await expect(stepProgress(page)).toContainText('Step 7 of 7')
    await page.getByRole('button', { name: 'Generate report' }).click()

    // Should now be on the download page
    await expect(page).toHaveURL(/download-report/)
    await expect(page.locator('.download-report')).toBeVisible()
  })

  test('whilst generating the user sees in-progress or queue status', async ({ page }) => {
    await page.goto(urls.atStep4Country)
    await page.locator('input[name="period[]"][value="ytd"]').check()
    await clickNext(page)
    await page.locator('input[name="age"][value="any"]').check()
    await clickNext(page)
    await page.getByRole('button', { name: 'Generate report' }).click()

    await expect(page).toHaveURL(/download-report/)

    // Report will be in one of: pending (queue position), in-progress (ETA), or completed
    const statusLocator = page.locator(
      '.o-request--status__pending, .o-request--status__in-progress, .o-request--status__success',
    )
    await expect(statusLocator).toBeVisible({ timeout: 15_000 })
  })

  // XLS and CSV download link tests are not included here because queue completion time is
  // non-deterministic and makes live E2E tests unreliable. The recommended approach when
  // this needs to be covered is to use page.route() to intercept the ?_partial=true polling
  // request and return a fake completed-report HTML fragment, allowing the client-side
  // DOM-swap logic and link rendering to be verified without any queue dependency.

  test('the user can click to return to the first step', async ({ page }) => {
    await page.goto(urls.atStep4Country)
    await page.locator('input[name="period[]"][value="ytd"]').check()
    await clickNext(page)
    await page.locator('input[name="age"][value="any"]').check()
    await clickNext(page)
    await page.getByRole('button', { name: 'Generate report' }).click()

    await expect(page).toHaveURL(/download-report/)
    await page.getByRole('link', { name: 'return to the start' }).click()
    await expect(page).toHaveURL(/report-design/)
    await expect(stepProgress(page)).toContainText('Step 1 of 7')
  })
})
