-- ERROR:
-- Invalid use of group function
-- SELECT
--   CAST(PS.var["PS_PARTKEY"] AS INT),
--   SUM(CAST(PS.var["PS_SUPPLYCOST"] AS DOUBLE) * CAST(PS.var["PS_AVAILQTY"] AS INT)) AS VALUE
-- FROM
--   partsupp PS,
--   supplier S,
--   nation N
-- WHERE
--   CAST(PS.var["PS_SUPPKEY"] AS INT) = CAST(S.var["S_SUPPKEY"] AS INT)
--   AND CAST(S.var["S_NATIONKEY"] AS INT) = CAST(N.var["N_NATIONKEY"] AS INT)
--   AND CAST(N.var["N_NAME"] AS TEXT) = 'GERMANY'
-- GROUP BY
--   CAST(PS.var["PS_PARTKEY"] AS INT)
-- HAVING
--   SUM(CAST(PS.var["PS_SUPPLYCOST"] AS DOUBLE) * CAST(PS.var["PS_AVAILQTY"] AS INT)) > (
--     SELECT SUM(CAST(PSPS.var["PS_SUPPLYCOST"] AS DOUBLE) * CAST(PSPS.var["PS_AVAILQTY"] AS INT)) * 0.0001
--     FROM
--       partsupp PSPS,
--       supplier SS,
--       nation NN
--     WHERE
--       CAST(PSPS.var["PS_SUPPKEY"] AS INT) = CAST(SS.var["S_SUPPKEY"] AS INT)
--       AND CAST(SS.var["S_NATIONKEY"] AS INT) = CAST(NN.var["N_NATIONKEY"] AS INT)
--       AND CAST(NN.var["N_NAME"] AS TEXT) = 'GERMANY'
--   )
-- ORDER BY
--   VALUE DESC