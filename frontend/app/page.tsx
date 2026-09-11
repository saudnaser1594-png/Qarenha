"use client";

import { useState } from "react";

export default function Home() {
  const [search, setSearch] = useState("");

  const handleSearch = () => {
    if (!search.trim()) return;
    alert(`سيتم البحث عن: ${search}`);
  };

  return (
    <main className="min-h-screen bg-[#F8FAFC] text-[#172033]" dir="rtl">
      {/* Header */}
      <header className="border-b border-[#E2E8F0] bg-white">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-5">
          <div className="flex items-center gap-3">
            <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-[#0F2D4A] text-xl font-bold text-[#F4B942]">
              ق
            </div>

            <div>
              <h1 className="text-xl font-bold text-[#0F2D4A]">
                قارنها
              </h1>
              <p className="text-xs text-[#64748B]">
                محرك مقارنة الأسعار والمنتجات
              </p>
            </div>
          </div>

          <button className="rounded-lg border border-[#E2E8F0] px-4 py-2 text-sm font-medium text-[#0F2D4A] transition hover:bg-[#F8FAFC]">
            تسجيل الدخول
          </button>
        </div>
      </header>

      {/* Hero */}
      <section className="px-6 pb-16 pt-20">
        <div className="mx-auto max-w-5xl text-center">
          <div className="mb-5 inline-flex rounded-full bg-[#FFF7E0] px-4 py-2 text-sm font-medium text-[#9A6700]">
            قارن أكثر، وادفع أقل
          </div>

          <h2 className="text-4xl font-bold leading-tight text-[#0F2D4A] md:text-6xl">
            ابحث عن المنتج مرة واحدة
            <br />
            <span className="text-[#2563EB]">وقارن أفضل الأسعار</span>
          </h2>

          <p className="mx-auto mt-6 max-w-2xl text-lg leading-8 text-[#64748B]">
            قارنها يساعدك على مقارنة الأسعار والمواصفات والأحجام والألوان
            والتقييمات وتكاليف الشحن من متاجر متعددة في مكان واحد.
          </p>

          {/* Search */}
          <div className="mx-auto mt-10 flex max-w-3xl flex-col gap-3 rounded-2xl bg-white p-3 shadow-lg shadow-slate-200/60 md:flex-row">
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") handleSearch();
              }}
              placeholder="ابحث عن منتج، موديل، رقم قطعة أو باركود..."
              className="h-14 flex-1 rounded-xl border border-[#E2E8F0] bg-white px-5 text-base outline-none transition focus:border-[#2563EB] focus:ring-2 focus:ring-blue-100"
            />

            <button
              onClick={handleSearch}
              className="h-14 rounded-xl bg-[#2563EB] px-8 font-bold text-white transition hover:bg-[#1D4ED8]"
            >
              قارن الأسعار
            </button>
          </div>

          <p className="mt-4 text-sm text-[#94A3B8]">
            مثال: iPhone 17 Pro 256GB
          </p>
        </div>
      </section>

      {/* Features */}
      <section className="border-y border-[#E2E8F0] bg-white px-6 py-14">
        <div className="mx-auto max-w-6xl">
          <div className="mb-10 text-center">
            <h3 className="text-2xl font-bold text-[#0F2D4A]">
              ماذا يمكنك مقارنته؟
            </h3>
            <p className="mt-2 text-[#64748B]">
              المقارنة لا تقتصر على السعر فقط
            </p>
          </div>

          <div className="grid gap-5 md:grid-cols-3">
            <Feature
              icon="💰"
              title="أفضل سعر"
              description="اعثر على أرخص عرض متاح للمنتج."
            />

            <Feature
              icon="📦"
              title="المواصفات والخيارات"
              description="قارن الحجم واللون والسعة والذاكرة والمواصفات."
            />

            <Feature
              icon="🚚"
              title="الشحن والتوصيل"
              description="قارن تكلفة الشحن ووقت التوصيل عندما تتوفر البيانات."
            />

            <Feature
              icon="⭐"
              title="التقييمات"
              description="شاهد تقييم المنتج والبائع للمساعدة في اتخاذ القرار."
            />

            <Feature
              icon="🏷️"
              title="العلامة التجارية"
              description="قارن المنتجات حسب العلامة التجارية والموديل."
            />

            <Feature
              icon="🔎"
              title="بحث ذكي"
              description="ابحث باسم المنتج أو الموديل أو رقم القطعة أو الباركود."
            />
          </div>
        </div>
      </section>

      {/* Categories */}
      <section className="px-6 py-16">
        <div className="mx-auto max-w-6xl">
          <div className="mb-8">
            <h3 className="text-2xl font-bold text-[#0F2D4A]">
              تصفح حسب الفئة
            </h3>
            <p className="mt-2 text-[#64748B]">
              الفلاتر ستتغير حسب نوع المنتج الذي تبحث عنه.
            </p>
          </div>

          <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
            <Category title="الإلكترونيات" icon="📱" />
            <Category title="الملابس" icon="👕" />
            <Category title="الجمال والعناية" icon="🧴" />
            <Category title="قطع السيارات" icon="🚗" />
            <Category title="المنزل" icon="🏠" />
            <Category title="مواد البناء" icon="🧱" />
            <Category title="الأدوات" icon="🔧" />
            <Category title="منتجات عامة" icon="🛍️" />
          </div>
        </div>
      </section>

      {/* Example result */}
      <section className="bg-[#0F2D4A] px-6 py-16 text-white">
        <div className="mx-auto max-w-6xl">
          <div className="mb-8">
            <p className="text-sm font-medium text-[#F4B942]">
              مثال على نتيجة المقارنة
            </p>

            <h3 className="mt-2 text-2xl font-bold">
              المنتج المناسب بالمواصفات التي تختارها
            </h3>
          </div>

          <div className="overflow-hidden rounded-2xl bg-white text-[#172033]">
            <div className="flex flex-col gap-5 p-6 md:flex-row md:items-center md:justify-between">
              <div>
                <p className="text-sm text-[#64748B]">Apple</p>
                <h4 className="mt-1 text-xl font-bold">
                  iPhone 17 Pro 256GB
                </h4>

                <div className="mt-3 flex flex-wrap gap-2">
                  <span className="rounded-lg bg-slate-100 px-3 py-1 text-sm">
                    256GB
                  </span>

                  <span className="rounded-lg bg-slate-100 px-3 py-1 text-sm">
                    أسود
                  </span>

                  <span className="rounded-lg bg-slate-100 px-3 py-1 text-sm">
                    ⭐ 4.8
                  </span>
                </div>
              </div>

              <div className="text-right">
                <p className="text-sm text-[#64748B]">أفضل سعر</p>
                <p className="mt-1 text-3xl font-bold text-[#16A34A]">
                  4,299 ر.س
                </p>
                <p className="mt-1 text-sm text-[#64748B]">
                  شامل السعر الأساسي
                </p>
              </div>

              <button className="rounded-xl bg-[#2563EB] px-6 py-3 font-bold text-white hover:bg-[#1D4ED8]">
                عرض المتاجر
              </button>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-white px-6 py-8">
        <div className="mx-auto flex max-w-6xl flex-col items-center justify-between gap-4 text-sm text-[#64748B] md:flex-row">
          <p>© 2026 قارنها — Qarenha</p>

          <p>
            مقارنة المنتجات والأسعار في مكان واحد
          </p>
        </div>
      </footer>
    </main>
  );
}

function Feature({
  icon,
  title,
  description,
}: {
  icon: string;
  title: string;
  description: string;
}) {
  return (
    <div className="rounded-2xl border border-[#E2E8F0] bg-[#F8FAFC] p-6 transition hover:-translate-y-1 hover:shadow-md">
      <div className="text-3xl">{icon}</div>

      <h4 className="mt-4 text-lg font-bold text-[#0F2D4A]">
        {title}
      </h4>

      <p className="mt-2 leading-7 text-[#64748B]">
        {description}
      </p>
    </div>
  );
}

function Category({
  title,
  icon,
}: {
  title: string;
  icon: string;
}) {
  return (
    <button className="flex items-center gap-3 rounded-xl border border-[#E2E8F0] bg-white p-5 text-right font-medium text-[#0F2D4A] transition hover:border-[#2563EB] hover:shadow-sm">
      <span className="text-2xl">{icon}</span>
      <span>{title}</span>
    </button>
  );
}
