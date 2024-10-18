# epid8010-final-project

This repo contains everything for my EPID 8010 Final project.

The goal of this project is to investigate the role of breast cancer subtype in overall survival of women with inflammatory breat cancer.  This project was inspired by the work of Pan et al. in "Nomogram for predicting the overall survival of patients with inflammatory breast cancer: A SEER-based study" (2019). 

## Introduction

For now, these are notes that I have read about IBC or other relevant material. Include the references in all.  This will be helpful when writing the introduction section of the final report.

* "T4 (includes T4a, T4b, T4c, and T4d): Tumor of any size growing into the chest wall or skin. This includes inflammatory breast cancer." https://www.cancer.org/cancer/types/breast-cancer/understanding-a-breast-cancer-diagnosis/stages-of-breast-cancer.html#:~:text=T1%20(includes%20T1a%2C%20T1b%2C,the%20chest%20wall%20or%20skin.

* "Inflammatory breast cancer (IBC) is rare. It accounts for only 1% to 5% of all breast cancers. Although it is a type of invasive ductal carcinoma, its symptoms, outlook, and treatment are different. IBC causes symptoms of breast inflammation like swelling and redness, which is caused by cancer cells blocking lymph vessels in the skin causing the breast to look "inflamed." " https://www.cancer.org/cancer/types/breast-cancer/about/types-of-breast-cancer/inflammatory-breast-cancer.html

* "IBC doesn't look like a typical breast cancer. It often does not cause a breast lump, and it might not show up on a mammogram. This makes it harder to diagnose., IBC tends to occur in younger women (younger than 40 years of age)., Black women appear to develop IBC more often than White women., IBC is more common among women who are overweight or obese.
IBC tends to be more aggressive—it grows and spreads much more quickly—than more common types of breast cancer., IBC is always at least at a locally advanced stage when it’s first diagnosed because the breast cancer cells have grown into the skin. (This means it is at least stage III.), In about 1 of 3 cases, IBC has already spread (metastasized) to distant parts of the body when it is diagnosed. This makes it harder to treat successfully., Women with IBC tend to have a worse prognosis (outcome) than women with other common types of breast cancer." https://www.cancer.org/cancer/types/breast-cancer/about/types-of-breast-cancer/inflammatory-breast-cancer.html

* "All inflammatory breast cancers start as stage III (T4dNXM0) since they involve the skin. If the cancer has spread outside the breast to distant parts of the body, it is stage IV." https://www.cancer.org/cancer/types/breast-cancer/about/types-of-breast-cancer/inflammatory-breast-cancer.html

* "Inflammatory breast cancer (IBC) that has not spread outside the breast is stage III. In most cases, treatment is chemotherapy first to try to shrink the tumor, followed by surgery to remove the cancer. Radiation and often other treatments, like more chemotherapy or targeted drug therapy, are given after surgery. Because IBC is so aggressive, breast conserving surgery (lumpectomy) and sentinel lymph node biopsy are typically not part of the treatment. IBC that has spread to other parts of the body (stage IV) may be treated with chemotherapy, hormone therapy, and/or targeted drugs." https://www.cancer.org/cancer/types/breast-cancer/about/types-of-breast-cancer/inflammatory-breast-cancer.html

* "The most common and widely accepted classification of breast cancer is from an immunohistochemical perspective, based on the expression of the following hormone receptors: estrogen (ER), progesterone (PR) and human epidermal growth factor (HER2). Accordingly, the following four subtypes of breast cancer are widely recognized: luminal A, luminal B, HER2-positive, and triple-negative. " https://www.ncbi.nlm.nih.gov/books/NBK583808/#:~:text=Accordingly%2C%20the%20following%20four%20subtypes,positive%2C%20and%20triple%2Dnegative.

## Research Question 

How is breast cancer subtype associated with overall survival of women with inflammatory breast cancer?

## Data
Incidence – SEER Research Data, 17 Registries, Nov 2023 Sub (2000-2021)

The specififc criteria to identify paitents with inflammatory breat cancer (IBC) is as follows:

1. Site and Morphology was limited to "Breast" (TNM 7/CS V0204+ SCHEMA RECODE)
2. Derived TNM classification, AJCC 7th edition (2010-2015) was limited to "T4d", and Derived SEER combined T (2016-2017) was limited to "cT4D" and "pT4D", and Derived EOD 2018 T (2018+) was limited to "T4D". This is what limits to IBC.
3. **I think this was done automatically but need to check** Limit research to between 2010 and (likely) 2021. This is because the AJCC TNM 7th edition staging system was published in 2010 and because SEER started collecting breast cancer subtype in 2010.

The following variables are selected for inclusion in the data:
* **AGE RECODE WITH <1 YEAR OLDS AND 90+**:  This recode has 19 age groups in the age recode variable (< 1 year, 1-4 years, 5-9 years, ..., 85+ years).
* **Sex**: Male and Female. Variable includes an Umknown option but there doesnt appear to be any in the data
* **Year of Diagnosis**
* **Race/ethnicity**
* **Marital Status at diagnosis**: Divorced, Married (including common law), Separated, Single (never married), Unknown, Unmarried or Domestic Partner, Widowed
* **Derived TNM classification, AJCC 7th edition (2010-2015)**, **Derived SEER combined T (2016-2017)**, and **Derived EOD 2018 T (2018+)**: these can probably be removed, only the filtering was important
* **Breast Subtype (2010+)**: Her2+/HR+, Her2+/HR-, Her2-/HR+, Triple Negative, Unknown, Recode Not Available. for more info about these see Breast subtype notes.
* **Grade Recode (thru 2017)**: this has a lot of unknowns, might need to add **DERIVED SUMMARY GRADE 2018 (2018+)**
* **DERIVED AJCC N, 7TH ED (2010-2015)**: need to add something for 2016+. I don't see anything available in data so may need to drop
* **DERIVED AJCC M, 7TH ED (2010-2015)**: need to add something for 2016+. I don't see anything available in data so may need to drop
* **Radiation recode**: None/Unknown; diagnosed at autopsy, Beam radiation, Radioactive implants, Radioisotopes, Combination of 1 with 2 or 3, Radiation, NOS—method or source not specified, Other radiation (1973-1987 cases only), Patient or patient's guardian refused radiation therapy, Radiation recommended, unknown if administered
* **Chemotherapy recode**: No/Unknown, Yes
* **RX SUMM—SURG PRIM SITE (1998+)**: From SEER data description, "Surgery of Primary Site describes a surgical procedure that removes and/or destroys tissue of the primary site performed as part of the initial work-up or first course of therapy". There are a variety of codes. It may be useful to make this yes/no.
* **Survival months**: "Created using complete dates, including days, therefore may differ from survival time calculated from year and month only."
* **Vital status recode**: "Any patient that dies after the follow-up cut-off date is recoded to alive as of the cut-off date." if there is a cause of death that may be useful, maybe **SEER CAUSE-SPECIFIC DEATH CLASSIFICATION** and **SEER OTHER CAUSE OF DEATH CLASSIFICATION**






