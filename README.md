---
editor_options: 
  markdown: 
    wrap: 72
---

# epid8010-final-project

This repo contains everything for my EPID 8010 final project.

The goal of this project is to investigate the role of breast cancer
subtype in overall survival of adult women with inflammatory breast
cancer.\
This project was inspired by the work of Pan et al. in "Nomogram for
predicting the overall survival of patients with inflammatory breast
cancer: A SEER-based study" (2019).

## Introduction

For now, these are notes that I have read about IBC or other relevant
material. Include the references in all.\
This will be helpful when writing the introduction section of the final
report.

-   "T4 (includes T4a, T4b, T4c, and T4d): Tumor of any size growing
    into the chest wall or skin. This includes inflammatory breast
    cancer."
    <https://www.cancer.org/cancer/types/breast-cancer/understanding-a-breast-cancer-diagnosis/stages-of-breast-cancer.html#>:\~:text=T1%20(includes%20T1a%2C%20T1b%2C,the%20chest%20wall%20or%20skin.

-   "Inflammatory breast cancer (IBC) is rare. It accounts for only 1%
    to 5% of all breast cancers. Although it is a type of invasive
    ductal carcinoma, its symptoms, outlook, and treatment are
    different. IBC causes symptoms of breast inflammation like swelling
    and redness, which is caused by cancer cells blocking lymph vessels
    in the skin causing the breast to look "inflamed." "
    <https://www.cancer.org/cancer/types/breast-cancer/about/types-of-breast-cancer/inflammatory-breast-cancer.html>

-   "IBC doesn't look like a typical breast cancer. It often does not
    cause a breast lump, and it might not show up on a mammogram. This
    makes it harder to diagnose., IBC tends to occur in younger women
    (younger than 40 years of age)., Black women appear to develop IBC
    more often than White women., IBC is more common among women who are
    overweight or obese. IBC tends to be more aggressive—it grows and
    spreads much more quickly—than more common types of breast cancer.,
    IBC is always at least at a locally advanced stage when it’s first
    diagnosed because the breast cancer cells have grown into the skin.
    (This means it is at least stage III.), In about 1 of 3 cases, IBC
    has already spread (metastasized) to distant parts of the body when
    it is diagnosed. This makes it harder to treat successfully., Women
    with IBC tend to have a worse prognosis (outcome) than women with
    other common types of breast cancer."
    <https://www.cancer.org/cancer/types/breast-cancer/about/types-of-breast-cancer/inflammatory-breast-cancer.html>

-   "All inflammatory breast cancers start as stage III (T4dNXM0) since
    they involve the skin. If the cancer has spread outside the breast
    to distant parts of the body, it is stage IV."
    <https://www.cancer.org/cancer/types/breast-cancer/about/types-of-breast-cancer/inflammatory-breast-cancer.html>

-   "Inflammatory breast cancer (IBC) that has not spread outside the
    breast is stage III. In most cases, treatment is chemotherapy first
    to try to shrink the tumor, followed by surgery to remove the
    cancer. Radiation and often other treatments, like more chemotherapy
    or targeted drug therapy, are given after surgery. Because IBC is so
    aggressive, breast conserving surgery (lumpectomy) and sentinel
    lymph node biopsy are typically not part of the treatment. IBC that
    has spread to other parts of the body (stage IV) may be treated with
    chemotherapy, hormone therapy, and/or targeted drugs."
    <https://www.cancer.org/cancer/types/breast-cancer/about/types-of-breast-cancer/inflammatory-breast-cancer.html>

-   "The most common and widely accepted classification of breast cancer
    is from an immunohistochemical perspective, based on the expression
    of the following hormone receptors: estrogen (ER), progesterone (PR)
    and human epidermal growth factor (HER2). Accordingly, the following
    four subtypes of breast cancer are widely recognized: luminal A,
    luminal B, HER2-positive, and triple-negative. "
    <https://www.ncbi.nlm.nih.gov/books/NBK583808/#>:\~:text=Accordingly%2C%20the%20following%20four%20subtypes,positive%2C%20and%20triple%2Dnegative.

-   "Breast cancer has four primary molecular subtypes, defined in large
    part by hormone receptors (HR) and other types of proteins involved
    (or not involved) in each cancer: Luminal A or HR+/HER2-
    (HR-positive/HER2-negative) Luminal B or HR+/HER2+
    (HR-positive/HER2-positive) Triple-negative or HR-/HER2-
    (HR/HER2-negative) HER2-positive"
    <https://www.cancercenter.com/cancer-types/breast-cancer/types/breast-cancer-molecular-types#>:\~:text=Breast%20cancer%20has%20four%20primary,(HR%2FHER2%2Dnegative)

## Research Question

How is breast cancer subtype associated with overall survival of adult
women with inflammatory breast cancer?

## Data

Incidence – SEER Research Data, 17 Registries, Nov 2023 Sub (2000-2021)

The exact filtering input is:

{Age at Diagnosis.Age recode with \<1 year olds} = '15-19 years','20-24
years','25-29 years','30-34 years','35-39 years','40-44 years','45-49
years','50-54 years','55-59 years','60-64 years','65-69 years','70-74
years','75-79 years','80-84 years','85+ years' AND {Site and
Morphology.Site recode ICD-O-3/WHO 2008} = ' Breast' AND {Race, Sex,
Year Dx.Year of diagnosis} =
'2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021'
AND {Race, Sex, Year Dx.Sex} = ' Female' AND {Stage - 8th
edition.Derived EOD 2018 T (2018+)} = 'T4d' OR {Stage - 7th
edition.Derived AJCC T, 7th ed (2010-2015)} = 'T4d' OR {Stage - 7th
edition.Derived SEER Combined T (2016-2017)} = 'c2D' OR {Stage - 7th
edition.Derived SEER Combined T (2016-2017)} = 'p4D'

FOR SOME REASON THERE ARE MALES STILL IN THE DATA. I CAN FILTER THIS OUT
MANUALLY AND CHECK THAT OTHER SPECIFICATIONS WERE MET.

The specific criteria to identify patients with inflammatory breast
cancer (IBC) is as follows:

1.  Site and Morphology was limited to "Breast" (TNM 7/CS V0204+ SCHEMA
    RECODE)
2.  Derived TNM classification, AJCC 7th edition (2010-2015) was limited
    to "T4d", and Derived SEER combined T (2016-2017) was limited to
    "cT4D" and "pT4D", and Derived EOD 2018 T (2018+) was limited to
    "T4D". This is what limits to IBC.
3.  Age was limited to 20 years and older to target adult women.
4.  Sex was limited to Female.
5.  Limit research to cases diagnosed between 2010 and 2021. This is
    because the AJCC TNM 7th edition staging system was published in
    2010 and because SEER started collecting breast cancer subtype
    in 2010. The data available is through 2021.
6.  Limit analysis to individuals who have survival months \>= 1.

The following variables are selected for inclusion in the data:

-   **AGE RECODE WITH \<1 YEAR OLDS AND 90+**: This recode has 19 age
    groups in the age recode variable (\< 1 year, 1-4 years, 5-9 years,
    ..., 85+ years). Limit to 20 years and older.

-   **Sex**: Male and Female. Variable includes an Unknown option but
    there doesn't appear to be any in the data. Limit to Female, only.

-   **Year of Diagnosis**: Limit to 2010 - 2021.

-   **Race/ethnicity:** Recode to three categories only - White, Black,
    Other.

-   **Marital Status at diagnosis**: Original variable has categories -
    Divorced, Married (including common law), Separated, Single (never
    married), Unknown, Unmarried or Domestic Partner, Widowed. Recode to
    Yes (if original variable is "Married (including common law)" and No
    (otherwise)

-   **Derived TNM classification, AJCC 7th edition (2010-2015)**,
    **Derived SEER combined T (2016-2017)**, and **Derived EOD 2018 T
    (2018+)**: these were included to cross-validate T-stage then were
    removed

-   **Breast Subtype (2010+)**: Original variable has categories -
    Her2+/HR+, Her2+/HR-, Her2-/HR+, Triple Negative, Unknown, Recode
    Not Available. for more info about these see Breast subtype notes.

    -   Recode to Luminal A (HR+/HER2-), Luminal B (HR+/Her2+), HER2
        Positive (HR-/HER2+), Triple Negative (HR-/HER2-)
    -   390 individuals have unknown subtype. These were removed

-   **Grade Recode (thru 2017)**and **DERIVED SUMMARY GRADE 2018
    (2018+). Histologic Type ICD-O-3 which seems probably has
    documentation somewhere on how to convert to grade but eems like it
    might be tedious**

    -   grade 2017 field description says "Set to unknown for breast
        cases with conflicting data for Nottingham or BloomRichardson
        (BR) Score/Grade in 2010-2017. Based on grade codes in ICD-O-3."

    -   **Histologic Type ICD-O-3** might be useful if can find
        documentation on the conversion

    -   4 people have grade2017 "B-cell; pre-B; B-precursor". 1 person
        has grade 2017 "T-cell". exclude these 5 people from analysis

    -   there are 1087 individuals with NA grade2017 and grade 2018

    -   grade 2018 clinical details at
        <https://apps.naaccr.org/ssdi/input/breast/grade_clin/?breadcrumbs=>(~schema_list~),(~view_schema~,~breast~)

    -   one way to potentially deal with the unknown grade values is to
        make a table of idc_type by grade and see, among the idc
        numbers, what the most common grade is. then for unknown grades
        with that idc_type, assign them to the most common grade.

    -   the literature suggests that there was conflicting grading
        schema. depending what the results show, either drop grade
        variable and keep all obs or remove all NA obs and keep grade
        variable

-   **DERIVED AJCC N, 7TH ED (2010-2015), DERIVED SEER COMBINED N
    (2016-2017)** and **DERIVED EOD 2018 N**

    -   some documentation on the meaning:
        <https://staging.seer.cancer.gov/tnm/input/1.3/breast/path_n/>[?(%7Eview_schema%7E,%7Ebreast%7E)](https://staging.seer.cancer.gov/tnm/schema/2.0/breast/?breadcrumbs=(schema_list))

    -   there are clinical and pathological measurements for 2016-217
        only. clinical was taken before surgerey to remove tumor and
        pathological was taken after. I think they best way to handle
        this would be to just group together. this can be mentioned in
        the limitations.

    -   I also recode to create a N stage variable with 5 categories:
        N0, N1, N2, N3, NX. NX means lymph nodes could not be evaluated.
        213 individuals have this, should they be dropped?

-   **DERIVED AJCC N, 7TH ED (2010-2015), DERIVED SEER COMBINED N
    (2016-2017)** and **DERIVED EOD 2018 N**

    -   documentation at
        <https://staging.seer.cancer.gov/tnm/input/1.3/breast/clin_m/?breadcrumbs=>(~schema_list~),(~view_schema~,~breast~)

    -   2016-2017 has 9 individuals with pathological measurements. I'm
        handling this same as the n stage

    -   Recode as M0 and M1

-   **Radiation recode**: Original variable has categories -
    None/Unknown; diagnosed at autopsy, Beam radiation, Radioactive
    implants, Radioisotopes, Combination of 1 with 2 or 3, Radiation,
    NOS—method or source not specified, Other radiation (1973-1987 cases
    only), Patient or patient's guardian refused radiation therapy,
    Radiation recommended, unknown if administered

    -   Recode as No/Unknown, Yes

-   **Chemotherapy recode**: No/Unknown, Yes

-   **RX SUMM—SURG PRIM SITE (1998+)**: From SEER data description,
    "Surgery of Primary Site describes a surgical procedure that removes
    and/or destroys tissue of the primary site performed as part of the
    initial work-up or first course of therapy". There are a variety of
    codes. It may be useful to make this yes/no.

    -   Recode as No/Unknown, Yes

-   **Survival months**: "Created using complete dates, including days,
    therefore may differ from survival time calculated from year and
    month only."

    -   Limit analysis to \>= 1

-   **Vital status recode**, **SEER CAUSE-SPECIFIC DEATH
    CLASSIFICATION** and **SEER OTHER CAUSE OF DEATH CLASSIFICATION**

    -   These are included to ensure that all individuals included in
        the analysis who experienced the outcome (death) did so because
        of the cancer and not some other cause.

    -   45 individuals have missing/unknown COD. remove these
        observations from the analysis

    -   494 people are dead of another cause, exclude from analysis

    -   Now everyone in the analysis is either alive or dead due to
        cancer
