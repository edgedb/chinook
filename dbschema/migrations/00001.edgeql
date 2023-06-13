CREATE MIGRATION m124ldyymw3m4uu7zho37ladgmcaqmolju3kkiagdjztq2b4uvsvza
    ONTO initial
{
  CREATE TYPE default::Artist {
      CREATE PROPERTY name: std::str;
  };
  CREATE TYPE default::Album {
      CREATE LINK artist: default::Artist;
      CREATE PROPERTY title: std::str;
  };
  CREATE TYPE default::Genre {
      CREATE PROPERTY name: std::str;
  };
  CREATE TYPE default::MediaType {
      CREATE PROPERTY name: std::str;
  };
  CREATE TYPE default::Track {
      CREATE LINK album: default::Album;
      CREATE LINK genre: default::Genre;
      CREATE LINK media_type: default::MediaType;
      CREATE PROPERTY bytes: std::int64;
      CREATE PROPERTY composer: std::str;
      CREATE PROPERTY milliseconds: std::int64;
      CREATE PROPERTY name: std::str;
      CREATE PROPERTY unit_price: std::decimal;
  };
  CREATE TYPE default::Employee {
      CREATE LINK reports_to: default::Employee;
      CREATE PROPERTY address: std::str;
      CREATE PROPERTY birth_date: cal::local_date;
      CREATE PROPERTY city: std::str;
      CREATE PROPERTY country: std::str;
      CREATE PROPERTY email: std::str;
      CREATE PROPERTY fax: std::str;
      CREATE PROPERTY first_name: std::str;
      CREATE PROPERTY hire_date: cal::local_date;
      CREATE PROPERTY last_name: std::str;
      CREATE PROPERTY phone: std::str;
      CREATE PROPERTY postal_code: std::str;
      CREATE PROPERTY state: std::str;
      CREATE PROPERTY title: std::str;
  };
  CREATE TYPE default::Customer {
      CREATE LINK support_rep: default::Employee;
      CREATE PROPERTY address: std::str;
      CREATE PROPERTY city: std::str;
      CREATE PROPERTY company: std::str;
      CREATE PROPERTY country: std::str;
      CREATE PROPERTY email: std::str;
      CREATE PROPERTY fax: std::str;
      CREATE PROPERTY first_name: std::str;
      CREATE PROPERTY last_name: std::str;
      CREATE PROPERTY phone: std::str;
      CREATE PROPERTY postal_code: std::str;
      CREATE PROPERTY state: std::str;
  };
  CREATE TYPE default::Invoice {
      CREATE LINK customer: default::Customer;
      CREATE MULTI LINK items: default::Track {
          CREATE PROPERTY quantity: std::int64;
          CREATE PROPERTY unit_price: std::decimal;
      };
      CREATE PROPERTY billing_address: std::str;
      CREATE PROPERTY billing_city: std::str;
      CREATE PROPERTY billing_country: std::str;
      CREATE PROPERTY billing_postal_code: std::str;
      CREATE PROPERTY billing_state: std::str;
      CREATE PROPERTY invoice_date: std::datetime;
      CREATE PROPERTY total: std::decimal;
  };
  CREATE TYPE default::Playlist {
      CREATE MULTI LINK tracks: default::Track;
      CREATE PROPERTY name: std::str;
  };
};
