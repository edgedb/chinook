CREATE MIGRATION m1f5eblwvc6phpz65fgfmsnw5xbuuggandvx7gum2e5zioe3dh4dcq
    ONTO m124ldyymw3m4uu7zho37ladgmcaqmolju3kkiagdjztq2b4uvsvza
{
  CREATE TYPE default::Content {
      CREATE PROPERTY name: std::str;
      CREATE PROPERTY unit_price: std::decimal;
  };
  CREATE TYPE default::Movie EXTENDING default::Content {
      CREATE PROPERTY release_year: std::int64;
  };
  ALTER TYPE default::Track EXTENDING default::Content LAST;
  ALTER TYPE default::Track {
      ALTER PROPERTY name {
          DROP OWNED;
          RESET TYPE;
      };
      ALTER PROPERTY unit_price {
          DROP OWNED;
          RESET TYPE;
      };
  };
};
