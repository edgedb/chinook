CREATE MIGRATION m1r4mkd5ayzkgym3skpc3jwvhoqlvarqc6ak2z6zo2h2irwes52pja
    ONTO m1f5eblwvc6phpz65fgfmsnw5xbuuggandvx7gum2e5zioe3dh4dcq
{
  ALTER TYPE default::Invoice {
      ALTER LINK items {
          SET TYPE default::Content;
      };
  };
};
