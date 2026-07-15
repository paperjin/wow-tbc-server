-- EOTS marks are handled differently - uses spell_template
-- Winners: 60 marks, Losers: 20 marks
UPDATE spell_template SET EffectBasePoints2 = 19 WHERE Id IN (24950, 24952, 24954);
UPDATE spell_template SET EffectBasePoints2 = 59 WHERE Id IN (24951, 24953, 24955);
