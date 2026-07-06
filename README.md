# Customer Churn Analysis

IBM Telco Customer Churn veri seti üzerinde SQL Server ve Power BI kullanılarak yapılan müşteri kaybı (churn) analizi projesi.

## Kullanılan Araçlar
- SQL Server (veri sorgulama ve analiz)
- Power BI (görselleştirme ve dashboard)

## Öne Çıkan Bulgular
- Genel churn oranı: %26,54
- En riskli müşteri segmenti: Month-to-month sözleşme + Fiber optic internet + Teknik destek almayan müşteriler
- Uzun dönemli sözleşmeler (1-2 yıl) ve teknik destek hizmeti churn oranını belirgin şekilde azaltıyor
- Otomatik ödeme yöntemleri (banka/kredi kartı) kullanan müşterilerde churn oranı daha düşük

## Veri Kalitesi Notu
Analiz sırasında MonthlyCharges sütununda kaynak veriden gelen bir sayısal bozulma tespit edildi (ondalık nokta kaybı). Sorun, TotalCharges ve tenure değişkenleri kullanılarak (MonthlyCharges = TotalCharges / tenure) yeniden hesaplanarak düzeltildi.

## Dosyalar
- `churn_analysis.sql`: Tüm SQL sorguları, bulgular ve yorumlar
- Power BI dashboard ekran görüntüleri
