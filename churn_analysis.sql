/* 
PROJECT: Customer Churn Analysis 
AUTHOR: Melike Uygur 
TOOLS: SQL Server, Power BI 
DATASET: IBM Telco Customer Churn Dataset */ 

/* Toplam Müşteri Sayısı
Amaç: Veri setinde ki toplam müşteri sayısını belirlemek */ 

SELECT COUNT (*) AS Total_Customers
FROM dbo.customer_churn_data;

/*Churn Dağılımı 
Amaç: Müşterilerin kaçının hizmeti bıraktığını belirlemek.*/

SELECT 
	Churn, 
	COUNT(*) AS Customer_Count
FROM dbo.customer_churn_data
GROUP BY Churn;

/* Sonuç:
1869 müşteri hizmeti bırakmıştır.
5174 müşteri hizmeti kullanmaya devam etmektedir. */

/* Churn Oranı Hesaplama 
Amaç: Müşteri kayıp oranını yüzde olarak hesaplamak.*/

SELECT ROUND( 
			COUNT (CASE WHEN Churn ='Yes' THEN 1 END ) * 100.0
			/ COUNT (*), 2 
			) AS Churn_Rate_Percentage
FROM dbo.customer_churn_data;

/*Yorum:
Müşterilerin yaklaşık %26,5'i şirketten ayrılmıştır.
Bu oran telekom sektörü için yüksek kabul edilebilir ve müşteri kaybını azaltmaya yönelik stratejiler geliştirilebilir.*/ 

/* Sözleşme Türüne Göre Churn Analizi
Amaç: Hangi sözleşme türündeki müşterilerin daha fazla şirketten ayrıldığını belirlemek.*/

SELECT 
	Contract,
	Churn,
	COUNT(*) AS Customer_Count 
FROM dbo.customer_churn_data
GROUP BY Contract, Churn 
ORDER BY Contract;

/* Yorum:
Aylık sözleşme (month-to-month) sahip müşterilerde, müşteri kaybı oldukça yüksektir.(1655 Müşteri)
İki yıllık sözleşmeye sahip müşterilerde ise müşteri kaybı oldukça düşüktür. (48 Müşteri) 
Bu veriler, uzun dönem sözleşmelerin müşteri sadakatini arttırdığını göstermektedir.*/ 

/* İnternet Hizmeti Türüne Göre Churn Analizi
Amaç: İnternet hizmeti türüne göre müşteri kaybını incelemek. */ 

SELECT 
	InternetService,
	Churn,
	COUNT(*) AS Customer_Count
FROM dbo.customer_churn_data
GROUP BY InternetService, Churn 
ORDER BY InternetService;

/*
Yorum:
Fiber optic hizmeti kullanan müşteriler arasında müşteri kaybı oldukça yüksektir.
Bu durum hizmet kalitesi, fiyatlandırma veya müşteri beklentileri ile ilişkili olabilir.
DSL kullanıcılarında müşteri kaybı daha düşük seviyededir.
İnternet hizmeti almayan müşterilerde ise churn oranı oldukça düşüktür.*/

/* Ödeme Yöntemine Göre Churn Analizi
Amaç: Hangi ödeme yöntemini kullanan müşterilerin daha fazla ayrıldığını belirlemek.*/ 

SELECT 
	PaymentMethod,
	Churn,
	COUNT(*) AS Customer_Count 
FROM dbo.customer_churn_data
GROUP BY PaymentMethod, Churn
ORDER BY PaymentMethod;

/* Yorum:
Electronic check kullanan müşteriler arasındamüşteri kaybı oldukça yüksektir. (1071 Müşteri)
Otomatik ödeme yöntemlerini (Bank transfer ve Credit Card Automatic) kullanan müşterilerde ise müşteri kaybı daha düşüktür. 
Bu durum, otomatik ödeme sistemlerinin müşteri bağlılığını artırabileceğini göstermektedir.
Şirket, Electronic check kullanan müşterilere yönelik müşteri tutundurma stratejileri geliştirebilir.*/ 

/* Teknik Destek Hizmeti ve Churn Analizi
Amaç: Teknik destek alan müşterilerin churn oranını incelemek. */

SELECT 
	TechSupport,
	Churn,
	COUNT(*) AS Customer_Count
FROM dbo.customer_churn_data
GROUP BY TechSupport, Churn 
ORDER BY TechSupport;

/* Yorum:
Teknik destek hizmeti almayan müşteriler arasında müşteri kaybı oldukça yüksektir. (1446 Müşteri ) 
Teknik destek hizmeti alan müşterilerden ise müşteri kaybı önemli ölçüde daha düşüktür. ( 310 Müşteri )
Bu sonuç, teknik destek hizmetinin müşteri memnuniyeti ve bağlılığını arttırdığını göstermektedir. 
Şirket, müşteri kaybını azaltmak amacıyla teknik destek hizmetlerinin kullanımını teşvik edebilir. */

/* Müşterinin Şirkette Kalma Süresine Göre Churn Analizi 
Amaç: Müşterilerin şirkette kalma süresi ile churn ilişkisini incelemek. */

SELECT 
	Churn, 
	ROUND(AVG(tenure),2) AS Average_Tenure
FROM dbo.customer_churn_data
GROUP BY Churn;

/* Yorum:
Şirketten ayrılan müşterilerin ortalama şirkette kalma süresi 17 ay iken,
ayrılmayan müşterilerin ortalama kalma süresi 37 aydır. 
Bu sonuç, müşteri şirkette ne kadar uzun süre kalırsa müşteri bağlılığının arttığını göstermektedir. */ 

/* Aylık Ücret ve Churn Analizi
Amaç: Aylık ücretlerin müşteri kaybı üzerindeki etkisini incelemek. */ 

SELECT 
	Churn,
	ROUND(AVG(MonthlyCharges),2) AS Average_Monthly_Charge
FROM dbo.customer_churn_data
GROUP BY Churn;

SELECT 
	MIN(MonthlyCharges) AS Min_Charge,
	MAX(MonthlyCharges) AS Max_Charge
FROM dbo.customer_churn_data;


/* Yorum:
MonthlyCharges değişkeninde veri kalitesi problemi tespit edilmiştir. 
Normal koşullarda bir telekom müşterisinin aylık faturası birkaç yüz birim seviyesinde olması beklenirken, 
bu veri setinde ortalama değerler 3000-4000 aralığında ve maksimum değer 11.875 gibi anormal derecede yüksek çıkmaktadır. 

Power BI Power Query katmanında yapılan incelemede sorunun yerel ayar (locale) kaynaklı bir ondalık ayracı hatası olmadığı, 
MonthlyCharges sütununun kaynak veride ondalık noktası kaybolmuş şekilde (örn. 29.85 yerine 2985) hatalı kaydedildiği fark edilmiştir.

Sütun, veri setinde doğru formatta bulunan TotalCharges ve tenure değişkenleri kullanılarak yeniden hesaplanmıştır: 
MonthlyCharges_Fixed = TotalCharges / tenure 
(tenure = 0 olan yeni müşteriler için orijinal MonthlyCharges / 100 ile yaklaşık değer kullanılmıştır.)

Bu düzeltme sonrasında ortalama aylık ücretler churn eden müşterilerde ~74, churn etmeyen müşterilerde ~61 olarak gerçekçi bir aralıkta hesaplanmıştır — 
bu da yüksek aylık ücret ödeyen müşterilerin churn etme eğiliminin daha fazla olduğunu göstermektedir. */ 

/* Düzeltilmiş MonthlyCharges ile Yeniden Hesaplama
Aşağıdaki sorgu, veri kalitesi sorunu tespit edildikten sonra TotalCharges/tenure ile türetilen düzeltilmiş değeri kullanmaktadır. */

SELECT 
	Churn,
	ROUND(AVG(
		CASE WHEN tenure = 0 THEN MonthlyCharges / 100.0
		     ELSE CAST(TotalCharges AS DECIMAL(10,2)) / tenure 
		END
	), 2) AS Average_Monthly_Charge_Fixed
FROM dbo.customer_churn_data
GROUP BY Churn;

/* Senior Citizen (Yaşlı Müşteriler) ve Churn Analizi
Amaç: Yaşlı müşteri kaybı davranışlarını incelemek. */


SELECT
    SeniorCitizen,
    Churn,
    COUNT(*) AS Customer_Count,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY SeniorCitizen),
        2
    ) AS Churn_Rate_Pct
FROM dbo.customer_churn_data
GROUP BY SeniorCitizen, Churn
ORDER BY SeniorCitizen;

/* Yorum:
Yaşlı müşteriler arasında müşteri kaybı oranı, yaşlı olmayan müşterilere göre daha yüksektir. 
Bu durum, yaşlı müşterilerin hizmet maliyetleri, kullanım zorlukları veya müşteri deneyimi gibi faktörlerden daha fazla etkilenebileceğini göstermektedir.
Şirket, yaşlı müşterilere yönelik özel destek ve sadakat programları geliştirerek müşteri kaybını azaltabilir. */


/* Partner Durumuna Göre Churn Analizi 
Amaç:Partneri olan ve olmayan müşterilerin churn davranışlarını incelemek. */ 

SELECT 
	Partner,
	Churn,
	COUNT(*) AS Customer_Count,
	ROUND( 100.0 * COUNT (*) / SUM(COUNT(*)) OVER ( PARTITION BY Partner), 2) as Churn_Rate_Pct
FROM dbo.customer_churn_data
GROUP BY Partner, Churn
ORDER BY Partner;

/* Yorum:
Partneri olmayan müşteriler arasında müşteri kaybı oranı, partneri olan müşterilere göre daha yüksektir. 
Bu durum, partneri olan müşterilerin hizmetleri daha uzun süre kullandığını ve şirkete daha bağlı olabileceğini göstermektedir. 
Şirketler, partneri olmayan müşterilere yönelik kampanyalar ve kişiselleştirilmiş teklifler sunarak müşteri kaybını azaltabilir. */


/* Dependents ve Churn Analizi 
Amaç: Bakmakla yükümlü olunan kişisi bulunan müşterilerin churn davranışlarını incelemek. */ 

SELECT	
	Dependents,
	Churn,
	COUNT(*) AS	Customer_Count,
	ROUND(100.0	*COUNT(*)/ SUM(COUNT(*)) OVER (PARTITION BY	Dependents),2) AS Churn_Rate_Pct
FROM dbo.customer_churn_data
GROUP BY Dependents,	Churn
ORDER BY Dependents;

/* Yorum:
Bakmakla yükümlü olduğu kişi bulunmayan müşteriler arasında müşteri kaybı oranı daha yüksektir.
Bakmakla yükümlü olduğu kişi bulunan müşterilerin ise şirkette kalma eğilimi daha fazladır. 
Bu durum, aile sorumluluğuna sahip müşterilerin hizmet sürekliliğine daha fazla önem verdiğini göstermektedir. 
Şirket, bakmakla yükümlü olduğu kişi bulunmayan müşterilere özel kampanyalar geliştirerek müşteri kaybını azaltabilir.*/


/* Çoklu Hat Kullanımı ve Churn Analizi
Amaç: Birden fazla telefon hattı kullanan müşterilerin churn davranışlarını incelemek. */

SELECT	
	MultipleLines,
	Churn,
	COUNT(*) AS Customer_Count,
	ROUND(100.0	* COUNT(*)/ SUM(COUNT(*)) OVER (PARTITION BY MultipleLines),2) AS Churn_Rate_Pct
FROM dbo.customer_churn_data
GROUP BY MultipleLines,	Churn
ORDER BY MultipleLines;

/* Yorum:
Birden fazla telefon hattı kullanan müşterilerin müşteri kaybı oranı, tek hat kullanan müşterilere göre biraz daha yüksektir. 
Bu durum, birden fazla hizmet kullanan müşterilerin maliyetlere daha duyarlı olabileceğini göstermektedir. 
Şirket, çoklu hat kullanan müşterilere özel indirim ve kampanyalar sunarak müşteri kaybını azaltabilir. */


/* Riskli Müşteri Segmentleri Analizi 
Amaç: Sözleşme türü, internet hizmeti ve teknik destek durumuna göre en riskli müşteri gruplarını belirlemek. */ 

SELECT	
	Contract,
	InternetService,
	TechSupport,
	Churn,
	COUNT(*) AS Customer_Count
FROM dbo.customer_churn_data
GROUP BY Contract,	
	InternetService,	
	TechSupport,
	Churn
HAVING Churn = 'Yes'
ORDER BY Customer_Count	DESC;

/* Yorum:
Aylık sözleşmeye sahip, fiber internet kullanan ve teknik destek almayan müşteriler arasında müşteri kaybı en yüksek seviyedir.
Buna karşılık, uzun dönem (1 veya 2 yıllık) sözleşmeye sahip ve teknik destek hizmeti alan müşterilerde churn oranı oldukça düşüktür. 
Bu sonuçlar, uzun dönem sözleşmelerin ve teknik destek hizmetlerinin müşteri sadakatini arttırdığını göstermektedir. 
Şirket, özellikle aylık sözleşmeye ship fiber internet kullanıcılarına teknik destek hizmetlerini teşvik ederek müşteri kaybını azaltabilir. */


/* Cinsiyete Göre Churn Analizi
Amaç: Kadın ve erkek müşteriler arasındaki churn davranışını incelemek. */ 

SELECT	
	gender,
	Churn,
	COUNT(*) AS Customer_Count
FROM dbo.customer_churn_data
GROUP BY gender, Churn
ORDER BY gender;

/* Yorum:
Kadın ve erkek müşteriler arasında müşteri kaybı sayıları birbirine oldukça yakındır.
Kadın müşterilerde churn sayısı 939, erkek müşterilerde ise 930'dur.
Bu sonuç, cinsiyet değişkeninin müşteri kaybı üzerinde tek başına belirgin bir farklılık oluşturmadığını göstermektedir. 
Müşteri kaybını açıklamada sözleşme türü, teknik destek, internet hizmeti ve ödeme yöntemi gibi değişkenler daha etkili görünmektedir.*/


