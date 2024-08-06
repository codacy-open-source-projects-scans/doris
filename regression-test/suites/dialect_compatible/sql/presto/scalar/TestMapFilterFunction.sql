set sql_dialect='presto';
set enable_fallback_to_original_planner=false;
set debug_skip_fold_constant=false;
-- SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> true); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> true);	                            ^	Encountered: ]	Expected: IDENTIFIER	
-- SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> false); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> false);	                            ^	Encountered: ]	Expected: IDENTIFIER	
-- SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> CAST (NULL AS BOOLEAN)); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> CAST ...	                            ^	Encountered: ]	Expected: IDENTIFIER	
-- SELECT map_filter(CAST(map(ARRAY[], ARRAY[]) AS MAP(BIGINT, VARCHAR)), (k, v) -> true); # error: errCode = 2, detailMessage = Syntax error in line 1:	...map_filter(CAST(map(ARRAY[], ARRAY[]) AS MAP(BIGINT, V...	                             ^	Encountered: ]	Expected: IDENTIFIER	
-- SELECT map_filter(map(ARRAY[1], ARRAY[NULL]), (k, v) -> v IS NULL); # error: errCode = 2, detailMessage = Unknown column 'ARRAY' in 'table list' in PROJECT clause
-- SELECT map_filter(map(ARRAY[1], ARRAY[NULL]), (k, v) -> v IS NOT NULL); # error: errCode = 2, detailMessage = Unknown column 'ARRAY' in 'table list' in PROJECT clause
-- SELECT map_filter(map(ARRAY[1], ARRAY[CAST (NULL AS INTEGER)]), (k, v) -> v IS NULL); # error: errCode = 2, detailMessage = Unknown column 'ARRAY' in 'table list' in PROJECT clause
-- SELECT map_filter(map(ARRAY[1, 2, 3], ARRAY[NULL, NULL, NULL]), (k, v) -> v IS NULL); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[1, 2, 3], ARRAY[NULL, NULL, N...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[1, 2, 3], ARRAY[NULL, NULL, NULL]), (k, v) -> v IS NOT NULL); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[1, 2, 3], ARRAY[NULL, NULL, N...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[5, 6, 7, 8], ARRAY[5, 6, 6, 5]), (x, y) -> x <= 6 OR y = 5); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[5, 6, 7, 8], ARRAY[5, 6, 6, 5...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[5 + RANDOM(1), 6, 7, 8], ARRAY[5, 6, 6, 5]), (x, y) -> x <= 6 OR y = 5); # error: errCode = 2, detailMessage = Syntax error in line 1:	...er(map(ARRAY[5 + RANDOM(1), 6, 7, 8], ARRAY[5, 6, 6, 5...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['a', 'b', 'c', 'd'], ARRAY[1, 2, NULL, 4]), (k, v) -> v IS NOT NULL); # error: errCode = 2, detailMessage = Syntax error in line 1:	...T map_filter(map(ARRAY['a', 'b', 'c', 'd'], ARRAY[1, 2...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['a', 'b', 'c'], ARRAY[TRUE, FALSE, NULL]), (k, v) -> v); # error: errCode = 2, detailMessage = Syntax error in line 1:	...T map_filter(map(ARRAY['a', 'b', 'c'], ARRAY[TRUE, FAL...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[TIMESTAMP '2020-05-10 12:34:56.123456789', TIMESTAMP '1111-05-10 12:34:56.123456789'], ARRAY[1, 2]), (k, v) -> year(k) = 1111); # error: errCode = 2, detailMessage = Syntax error in line 1:	...-05-10 12:34:56.123456789', TIMESTAMP '1111-05-10 12:3...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25, 26, 27], ARRAY[25, 26, 27]), (k, v) -> k = 25 OR v = 27); # error: errCode = 2, detailMessage = Syntax error in line 1:	...CT map_filter(map(ARRAY[25, 26, 27], ARRAY[25, 26, 27]...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25, 26, 27], ARRAY[25.5E0, 26.5E0, 27.5E0]), (k, v) -> k = 25 OR v = 27.5E0); # error: errCode = 2, detailMessage = Syntax error in line 1:	...CT map_filter(map(ARRAY[25, 26, 27], ARRAY[25.5E0, 26....	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25, 26, 27], ARRAY[false, null, true]), (k, v) -> k = 25 OR v); # error: errCode = 2, detailMessage = Syntax error in line 1:	...CT map_filter(map(ARRAY[25, 26, 27], ARRAY[false, null...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25, 26, 27], ARRAY['abc', 'def', 'xyz']), (k, v) -> k = 25 OR v = 'xyz'); # error: errCode = 2, detailMessage = Syntax error in line 1:	...CT map_filter(map(ARRAY[25, 26, 27], ARRAY['abc', 'def...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25, 26, 27], ARRAY[ARRAY['a', 'b'], ARRAY['a', 'c'], ARRAY['a', 'b', 'c']]), (k, v) -> k = 25 OR cardinality(v) = 3); # error: errCode = 2, detailMessage = Syntax error in line 1:	...CT map_filter(map(ARRAY[25, 26, 27], ARRAY[ARRAY['a', ...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[25, 26, 27]), (k, v) -> k = 25.5E0 OR v = 27); # error: errCode = 2, detailMessage = Syntax error in line 1:	...ap_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[25,...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[25.5E0, 26.5E0, 27.5E0]), (k, v) -> k = 25.5E0 OR v = 27.5E0); # error: errCode = 2, detailMessage = Syntax error in line 1:	...ap_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[25....	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[false, null, true]), (k, v) -> k = 25.5E0 OR v); # error: errCode = 2, detailMessage = Syntax error in line 1:	...ap_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[fal...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY['abc', 'def', 'xyz']), (k, v) -> k = 25.5E0 OR v = 'xyz'); # error: errCode = 2, detailMessage = Syntax error in line 1:	...ap_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY['ab...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[ARRAY['a', 'b'], ARRAY['a', 'c'], ARRAY['a', 'b', 'c']]), (k, v) -> k = 25.5E0 OR cardinality(v) = 3); # error: errCode = 2, detailMessage = Syntax error in line 1:	...ap_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[ARR...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[true, false], ARRAY[25, 26]), (k, v) -> k AND v = 25); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY[true, false], ARRAY[25, 26]), (k...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[false, true], ARRAY[25.5E0, 26.5E0]), (k, v) -> k OR v > 100); # error: errCode = 2, detailMessage = Syntax error in line 1:	...map_filter(map(ARRAY[false, true], ARRAY[25.5E0, 26.5E...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[true, false], ARRAY[false, null]), (k, v) -> NOT k OR v); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY[true, false], ARRAY[false, null]...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[false, true], ARRAY['abc', 'def']), (k, v) -> NOT k AND v = 'abc'); # error: errCode = 2, detailMessage = Syntax error in line 1:	...map_filter(map(ARRAY[false, true], ARRAY['abc', 'def']...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[true, false], ARRAY[ARRAY['a', 'b'], ARRAY['a', 'b', 'c']]), (k, v) -> k OR cardinality(v) = 3); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY[true, false], ARRAY[ARRAY['a', '...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[25, 26, 27]), (k, v) -> k = 's0' OR v = 27); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[25, 26,...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[25.5E0, 26.5E0, 27.5E0]), (k, v) -> k = 's0' OR v = 27.5E0); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[25.5E0,...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[false, null, true]), (k, v) -> k = 's0' OR v); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[false, ...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY['abc', 'def', 'xyz']), (k, v) -> k = 's0' OR v = 'xyz'); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY['abc', ...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[ARRAY['a', 'b'], ARRAY['a', 'c'], ARRAY['a', 'b', 'c']]), (k, v) -> k = 's0' OR cardinality(v) = 3); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[ARRAY['...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]], ARRAY[25, 26, 27]), (k, v) -> k = ARRAY[1, 2] OR v = 27); # error: errCode = 2, detailMessage = Syntax error in line 1:	...p_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]],...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]], ARRAY[25.5E0, 26.5E0, 27.5E0]), (k, v) -> k = ARRAY[1, 2] OR v = 27.5E0); # error: errCode = 2, detailMessage = Syntax error in line 1:	...p_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]],...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]], ARRAY[false, null, true]), (k, v) -> k = ARRAY[1, 2] OR v); # error: errCode = 2, detailMessage = Syntax error in line 1:	...p_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]],...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]], ARRAY['abc', 'def', 'xyz']), (k, v) -> k = ARRAY[1, 2] OR v = 'xyz'); # error: errCode = 2, detailMessage = Syntax error in line 1:	...p_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]],...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]], ARRAY[ARRAY['a', 'b'], ARRAY['a', 'b', 'c'], ARRAY['a', 'c']]), (k, v) -> cardinality(k) = 0 OR cardinality(v) = 3); # error: errCode = 2, detailMessage = Syntax error in line 1:	...p_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]],...	                             ^	Encountered: COMMA	Expected: ||	
set debug_skip_fold_constant=true;
-- SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> true); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> true);	                            ^	Encountered: ]	Expected: IDENTIFIER	
-- SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> false); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> false);	                            ^	Encountered: ]	Expected: IDENTIFIER	
-- SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> CAST (NULL AS BOOLEAN)); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[], ARRAY[]), (k, v) -> CAST ...	                            ^	Encountered: ]	Expected: IDENTIFIER	
-- SELECT map_filter(CAST(map(ARRAY[], ARRAY[]) AS MAP(BIGINT, VARCHAR)), (k, v) -> true); # error: errCode = 2, detailMessage = Syntax error in line 1:	...map_filter(CAST(map(ARRAY[], ARRAY[]) AS MAP(BIGINT, V...	                             ^	Encountered: ]	Expected: IDENTIFIER	
-- SELECT map_filter(map(ARRAY[1], ARRAY[NULL]), (k, v) -> v IS NULL); # error: errCode = 2, detailMessage = Unknown column 'ARRAY' in 'table list' in PROJECT clause
-- SELECT map_filter(map(ARRAY[1], ARRAY[NULL]), (k, v) -> v IS NOT NULL); # error: errCode = 2, detailMessage = Unknown column 'ARRAY' in 'table list' in PROJECT clause
-- SELECT map_filter(map(ARRAY[1], ARRAY[CAST (NULL AS INTEGER)]), (k, v) -> v IS NULL); # error: errCode = 2, detailMessage = Unknown column 'ARRAY' in 'table list' in PROJECT clause
-- SELECT map_filter(map(ARRAY[1, 2, 3], ARRAY[NULL, NULL, NULL]), (k, v) -> v IS NULL); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[1, 2, 3], ARRAY[NULL, NULL, N...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[1, 2, 3], ARRAY[NULL, NULL, NULL]), (k, v) -> v IS NOT NULL); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[1, 2, 3], ARRAY[NULL, NULL, N...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[5, 6, 7, 8], ARRAY[5, 6, 6, 5]), (x, y) -> x <= 6 OR y = 5); # error: errCode = 2, detailMessage = Syntax error in line 1:	SELECT map_filter(map(ARRAY[5, 6, 7, 8], ARRAY[5, 6, 6, 5...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[5 + RANDOM(1), 6, 7, 8], ARRAY[5, 6, 6, 5]), (x, y) -> x <= 6 OR y = 5); # error: errCode = 2, detailMessage = Syntax error in line 1:	...er(map(ARRAY[5 + RANDOM(1), 6, 7, 8], ARRAY[5, 6, 6, 5...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['a', 'b', 'c', 'd'], ARRAY[1, 2, NULL, 4]), (k, v) -> v IS NOT NULL); # error: errCode = 2, detailMessage = Syntax error in line 1:	...T map_filter(map(ARRAY['a', 'b', 'c', 'd'], ARRAY[1, 2...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['a', 'b', 'c'], ARRAY[TRUE, FALSE, NULL]), (k, v) -> v); # error: errCode = 2, detailMessage = Syntax error in line 1:	...T map_filter(map(ARRAY['a', 'b', 'c'], ARRAY[TRUE, FAL...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[TIMESTAMP '2020-05-10 12:34:56.123456789', TIMESTAMP '1111-05-10 12:34:56.123456789'], ARRAY[1, 2]), (k, v) -> year(k) = 1111); # error: errCode = 2, detailMessage = Syntax error in line 1:	...-05-10 12:34:56.123456789', TIMESTAMP '1111-05-10 12:3...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25, 26, 27], ARRAY[25, 26, 27]), (k, v) -> k = 25 OR v = 27); # error: errCode = 2, detailMessage = Syntax error in line 1:	...CT map_filter(map(ARRAY[25, 26, 27], ARRAY[25, 26, 27]...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25, 26, 27], ARRAY[25.5E0, 26.5E0, 27.5E0]), (k, v) -> k = 25 OR v = 27.5E0); # error: errCode = 2, detailMessage = Syntax error in line 1:	...CT map_filter(map(ARRAY[25, 26, 27], ARRAY[25.5E0, 26....	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25, 26, 27], ARRAY[false, null, true]), (k, v) -> k = 25 OR v); # error: errCode = 2, detailMessage = Syntax error in line 1:	...CT map_filter(map(ARRAY[25, 26, 27], ARRAY[false, null...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25, 26, 27], ARRAY['abc', 'def', 'xyz']), (k, v) -> k = 25 OR v = 'xyz'); # error: errCode = 2, detailMessage = Syntax error in line 1:	...CT map_filter(map(ARRAY[25, 26, 27], ARRAY['abc', 'def...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25, 26, 27], ARRAY[ARRAY['a', 'b'], ARRAY['a', 'c'], ARRAY['a', 'b', 'c']]), (k, v) -> k = 25 OR cardinality(v) = 3); # error: errCode = 2, detailMessage = Syntax error in line 1:	...CT map_filter(map(ARRAY[25, 26, 27], ARRAY[ARRAY['a', ...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[25, 26, 27]), (k, v) -> k = 25.5E0 OR v = 27); # error: errCode = 2, detailMessage = Syntax error in line 1:	...ap_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[25,...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[25.5E0, 26.5E0, 27.5E0]), (k, v) -> k = 25.5E0 OR v = 27.5E0); # error: errCode = 2, detailMessage = Syntax error in line 1:	...ap_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[25....	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[false, null, true]), (k, v) -> k = 25.5E0 OR v); # error: errCode = 2, detailMessage = Syntax error in line 1:	...ap_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[fal...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY['abc', 'def', 'xyz']), (k, v) -> k = 25.5E0 OR v = 'xyz'); # error: errCode = 2, detailMessage = Syntax error in line 1:	...ap_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY['ab...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[ARRAY['a', 'b'], ARRAY['a', 'c'], ARRAY['a', 'b', 'c']]), (k, v) -> k = 25.5E0 OR cardinality(v) = 3); # error: errCode = 2, detailMessage = Syntax error in line 1:	...ap_filter(map(ARRAY[25.5E0, 26.5E0, 27.5E0], ARRAY[ARR...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[true, false], ARRAY[25, 26]), (k, v) -> k AND v = 25); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY[true, false], ARRAY[25, 26]), (k...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[false, true], ARRAY[25.5E0, 26.5E0]), (k, v) -> k OR v > 100); # error: errCode = 2, detailMessage = Syntax error in line 1:	...map_filter(map(ARRAY[false, true], ARRAY[25.5E0, 26.5E...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[true, false], ARRAY[false, null]), (k, v) -> NOT k OR v); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY[true, false], ARRAY[false, null]...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[false, true], ARRAY['abc', 'def']), (k, v) -> NOT k AND v = 'abc'); # error: errCode = 2, detailMessage = Syntax error in line 1:	...map_filter(map(ARRAY[false, true], ARRAY['abc', 'def']...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[true, false], ARRAY[ARRAY['a', 'b'], ARRAY['a', 'b', 'c']]), (k, v) -> k OR cardinality(v) = 3); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY[true, false], ARRAY[ARRAY['a', '...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[25, 26, 27]), (k, v) -> k = 's0' OR v = 27); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[25, 26,...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[25.5E0, 26.5E0, 27.5E0]), (k, v) -> k = 's0' OR v = 27.5E0); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[25.5E0,...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[false, null, true]), (k, v) -> k = 's0' OR v); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[false, ...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY['abc', 'def', 'xyz']), (k, v) -> k = 's0' OR v = 'xyz'); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY['abc', ...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[ARRAY['a', 'b'], ARRAY['a', 'c'], ARRAY['a', 'b', 'c']]), (k, v) -> k = 's0' OR cardinality(v) = 3); # error: errCode = 2, detailMessage = Syntax error in line 1:	... map_filter(map(ARRAY['s0', 's1', 's2'], ARRAY[ARRAY['...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]], ARRAY[25, 26, 27]), (k, v) -> k = ARRAY[1, 2] OR v = 27); # error: errCode = 2, detailMessage = Syntax error in line 1:	...p_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]],...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]], ARRAY[25.5E0, 26.5E0, 27.5E0]), (k, v) -> k = ARRAY[1, 2] OR v = 27.5E0); # error: errCode = 2, detailMessage = Syntax error in line 1:	...p_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]],...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]], ARRAY[false, null, true]), (k, v) -> k = ARRAY[1, 2] OR v); # error: errCode = 2, detailMessage = Syntax error in line 1:	...p_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]],...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]], ARRAY['abc', 'def', 'xyz']), (k, v) -> k = ARRAY[1, 2] OR v = 'xyz'); # error: errCode = 2, detailMessage = Syntax error in line 1:	...p_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]],...	                             ^	Encountered: COMMA	Expected: ||	
-- SELECT map_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]], ARRAY[ARRAY['a', 'b'], ARRAY['a', 'b', 'c'], ARRAY['a', 'c']]), (k, v) -> cardinality(k) = 0 OR cardinality(v) = 3) # error: errCode = 2, detailMessage = Syntax error in line 1:	...p_filter(map(ARRAY[ARRAY[1, 2], ARRAY[3, 4], ARRAY[]],...	                             ^	Encountered: COMMA	Expected: ||	
