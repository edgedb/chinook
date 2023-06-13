module default {

    type Invoice {
        link customer: Customer;

        invoice_date: datetime;
        billing_address: str;
        billing_city: str;
        billing_state: str;
        billing_country: str;
        billing_postal_code: str;
        total: decimal;

        multi link items: Track {
            unit_price: decimal;
            quantity: int64;
        };
    };

    type Customer {
        first_name: str;
        last_name: str;
        company: str;
        address: str;
        city: str;
        state: str;
        country: str;
        postal_code: str;
        phone: str;
        fax: str;
        email: str;

        link support_rep: Employee;
    };
    type Employee {
        last_name: str;
        first_name: str;
        title: str;
        link reports_to: Employee;
        birth_date: cal::local_date;
        hire_date: cal::local_date;
        address: str;
        city: str;
        state: str;
        country: str;
        postal_code: str;
        phone: str;
        fax: str;
        email: str;
    };
    type Track {
        name: str;
        link album: Album;
        link media_type: MediaType;
        link genre: Genre;
        composer: str;
        milliseconds: int64;
        bytes: int64;
        unit_price: decimal;
    };

    type Genre {
        name: str;
    };

    type Album {
        title: str;
        link artist: Artist;
    };

    type Artist {
        name: str;
    };

    type MediaType {
        name: str;
    };

    type Playlist {
        name: str;
        multi link tracks: Track;
    };
}
