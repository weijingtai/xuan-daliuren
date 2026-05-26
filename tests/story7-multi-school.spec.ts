import { expect, type Page, test } from '@playwright/test';

const artifactsDir = 'test-results/story7';

async function openDevMultiSchool(page: Page) {
  await page.goto('/#/daliuren/dev');
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(10000); // Wait long enough for Flutter to bootstrap

  // Enable semantics
  await page.evaluate(() => {
    const placeholder = document.querySelector('flt-semantics-placeholder') as HTMLElement;
    if (placeholder) placeholder.click();
  });
  await page.waitForTimeout(5000);

  // Function to find and click semantics node by text
  const clickByText = async (text: string) => {
    return await page.evaluate((t) => {
      const walk = (node: Node): boolean => {
        if (node.nodeType === Node.ELEMENT_NODE) {
          const el = node as HTMLElement;
          const label = el.getAttribute('aria-label') || el.innerText || el.textContent || '';
          if (label === t || label.includes(t)) {
            el.click();
            return true;
          }
        }
        if (node.childNodes) {
          for (const child of node.childNodes) if (walk(child)) return true;
        }
        const shadow = (node as any).shadowRoot;
        if (shadow) if (walk(shadow)) return true;
        return false;
      };
      return walk(document.body);
    }, text);
  };

  // On DevPage, we need to click the segment
  // The label might be just "多流派调试"
  await clickByText('多流派调试');
  await page.waitForTimeout(2000);
}

async function assertExists(page: Page, text: string) {
  const result = await page.evaluate((t) => {
    const labels: string[] = [];
    const walk = (node: Node): boolean => {
      if (node.nodeType === Node.ELEMENT_NODE) {
        const el = node as HTMLElement;
        const label = el.getAttribute('aria-label') || el.innerText || el.textContent || '';
        if (label.trim()) labels.push(label.trim());
        if (label.includes(t)) return true;
      }
      if (node.childNodes) {
        for (const child of node.childNodes) if (walk(child)) return true;
      }
      const shadow = (node as any).shadowRoot;
      if (shadow) if (walk(shadow)) return true;
      return false;
    };
    const found = walk(document.body);
    return { found, labels };
  }, text);
  
  if (!result.found) {
    console.log(`COULD NOT FIND "${text}". Available labels:`, result.labels);
  }
  expect(result.found).toBe(true);
}

test.describe('Story 7 multi-school acceptance', () => {
  test('G7-PW-04 DevPage shows the multi-school verification section', async ({
    page,
  }) => {
    await openDevMultiSchool(page);

    await assertExists(page, '御定');
    await assertExists(page, '毕法赋');
    await assertExists(page, '样例课义文本');

    await page.screenshot({
      path: `${artifactsDir}/dev-yuding.png`,
      fullPage: true,
    });
  });

  test('G7-PW-05 DevPage can switch to the Bifa planned state', async ({
    page,
  }) => {
    await openDevMultiSchool(page);

    await page.evaluate(() => {
      const walk = (node: Node): boolean => {
        if (node.nodeType === Node.ELEMENT_NODE) {
          const el = node as HTMLElement;
          const label = el.getAttribute('aria-label') || el.innerText || el.textContent || '';
          if (label === '毕法赋') {
            el.click();
            return true;
          }
        }
        if (node.childNodes) {
          for (const child of node.childNodes) if (walk(child)) return true;
        }
        const shadow = (node as any).shadowRoot;
        if (shadow) if (walk(shadow)) return true;
        return false;
      };
      walk(document.body);
    });

    await page.waitForTimeout(2000);

    await assertExists(page, '毕法赋');
    await assertExists(page, '正在整理中');

    await page.screenshot({
      path: `${artifactsDir}/dev-bifa-planned.png`,
      fullPage: true,
    });
  });
});
