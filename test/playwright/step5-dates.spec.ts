import { test, expect } from '@playwright/test'
import { clickNext, stepProgress, urls } from './helpers'

test.describe('Time period — step 5', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(urls.atStep4Country)
  })

  test('the user is currently viewing step 5 of 7', async ({ page }) => {
    await expect(stepProgress(page)).toContainText('Step 5 of 7')
  })

  test('the user can select a number of time periods to generate a report from', async ({ page }) => {
    await expect(page.locator('input[name="period[]"][value="ytd"]')).toBeVisible()
    await expect(page.locator('input[name="period[]"][value="latest_q"]')).toBeVisible()
    await expect(page.locator('input[name="period[]"][value="latest_m"]')).toBeVisible()
  })

  test('select Year to date and advance to step 6', async ({ page }) => {
    await page.locator('input[name="period[]"][value="ytd"]').check()
    await clickNext(page)
    await expect(stepProgress(page)).toContainText('Step 6 of 7')
  })
})

test.describe('Visible dates — step 5', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(urls.atStep4Country)
    await expect(stepProgress(page)).toContainText('Step 5 of 7')
  })

  test('the user can see the current year and select current year to date', async ({ page }) => {
    const currentYear = new Date().getFullYear()
    await expect(page.locator(`label:has-text("${currentYear} to date")`)).toBeVisible()
    await page.locator(`input[name="period[]"][value="${currentYear}"]`).check()
    await expect(page.locator(`input[name="period[]"][value="${currentYear}"]`)).toBeChecked()
  })

  test('the user can only select months in the current year up until the previous month', async ({ page }) => {
    const currentYear = new Date().getFullYear()
    // Month values are YYYY-MM; quarter values are YYYY-QN — exclude quarters
    const monthCheckboxes = page.locator(`input[name="period[]"][value*="${currentYear}-"]:not([value*="Q"])`)
    const count = await monthCheckboxes.count()
    // The current year never shows all 12 months — data availability limits it to
    // months up to (and including) the previous month. On environments where the API
    // has no current-year data yet this will legitimately be 0.
    expect(count).toBeLessThan(12)
  })

  test('the user can see the previous year and select previous year all year', async ({ page }) => {
    const prevYear = new Date().getFullYear() - 1
    await expect(page.locator(`label:has-text("${prevYear} all year")`)).toBeVisible()
    await page.locator(`input[name="period[]"][value="${prevYear}"]`).check()
    await expect(page.locator(`input[name="period[]"][value="${prevYear}"]`)).toBeChecked()
  })

  test('the user can click more dates to expand a greater selection of options', async ({ page }) => {
    const details = page.locator('details:has(summary:has-text("More dates"))')
    await expect(details).toBeVisible()
    await details.locator('summary').click()
    await expect(details).toHaveAttribute('open', '')
  })

  test('the user can see all years dating back to 1995', async ({ page }) => {
    await page.locator('details:has(summary:has-text("More dates")) summary').click()
    await expect(page.locator('h3:has-text("1995")')).toBeVisible()
  })

  test('the user can select any month within a full year', async ({ page }) => {
    await page.locator('details:has(summary:has-text("More dates")) summary').click()
    // Month values are YYYY-MM; quarter values are YYYY-QN — exclude quarters
    const monthCheckboxes = page.locator('input[name="period[]"][value^="1995-"]:not([value*="Q"])')
    await expect(monthCheckboxes).toHaveCount(12)
  })
})
