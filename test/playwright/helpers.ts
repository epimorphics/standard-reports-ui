import type { Page } from '@playwright/test'

export const nextBtn = (page: Page) => page.locator('[data-action="next"]')
export const stepProgress = (page: Page) => page.locator('.c-heading-prefix')

export async function clickNext (page: Page): Promise<void> {
  await nextBtn(page).click()
}

function buildUrl (path: string, params: Record<string, string | string[]>): string {
  const qs = new URLSearchParams()
  for (const [key, val] of Object.entries(params)) {
    if (Array.isArray(val)) {
      for (const v of val) qs.append(key, v)
    } else {
      qs.set(key, val)
    }
  }
  return `${path}?${qs.toString()}`
}

const base = 'report-design'

/** Navigate directly to a workflow state at the given step. */
export const urls = {
  step1: base,
  atStep2: buildUrl(base, { report: 'avgPrice' }),
  atStep2Country: buildUrl(base, { report: 'avgPrice', areaType: 'country' }),
  atStep2Region: buildUrl(base, { report: 'avgPrice', areaType: 'region' }),
  atStep2County: buildUrl(base, { report: 'avgPrice', areaType: 'county' }),
  atStep2District: buildUrl(base, { report: 'avgPrice', areaType: 'district' }),
  atStep2PcArea: buildUrl(base, { report: 'avgPrice', areaType: 'pcArea' }),
  atStep2PcDistrict: buildUrl(base, { report: 'avgPrice', areaType: 'pcDistrict' }),
  atStep2PcSector: buildUrl(base, { report: 'avgPrice', areaType: 'pcSector' }),
  atStep3Country: buildUrl(base, { report: 'avgPrice', areaType: 'country', area: 'EW' }),
  atStep4Country: buildUrl(base, { report: 'avgPrice', areaType: 'country', area: 'EW', aggregate: 'none' }),
  atStep5Country: buildUrl(base, { 'report': 'avgPrice', 'areaType': 'country', 'area': 'EW', 'aggregate': 'none', 'period[]': 'ytd' }),
  atStep6Country: buildUrl(base, { 'report': 'avgPrice', 'areaType': 'country', 'area': 'EW', 'aggregate': 'none', 'period[]': 'ytd', 'age': 'any' }),
}
