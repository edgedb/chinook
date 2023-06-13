import datetime
import edgedb
import csv
import json
import uuid


class Seeder:
    def seed(self):
        self.client = edgedb.create_client()

        try:
            with open('data/id_mappings.json', 'r') as f:
                self.id_mappings = json.loads(f.read())
        except:
            self.id_mappings = {}

        try:
            self.csv_to_object('data/media_types.csv', 'MediaType', ['id', 'str'])
            self.csv_to_object('data/genres.csv', 'Genre', ['id', 'str'])
            self.csv_to_object('data/artists.csv', 'Artist', ['id', 'str'])
            self.csv_to_object(
                'data/albums.csv',
                'Album',
                ['id', 'str', ('artist', 'Artist')],
            )
            self.csv_to_object(
                'data/tracks.csv',
                'Track',
                [
                    'id',
                    'str',
                    ('album', 'Album'),
                    ('media_type', 'MediaType'),
                    ('genre', 'Genre'),
                    'str',
                    'int64',
                    'int64',
                    'decimal',
                ],
            )
            self.csv_to_object(
                'data/employees.csv',
                'Employee',
                [
                    'id',
                    'str',
                    'str',
                    'str',
                    ('reports_to', 'Employee'),
                    'cal::local_date',
                    'cal::local_date',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                ],
            )
            self.csv_to_object(
                'data/customers.csv',
                'Customer',
                [
                    'id',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    ('support_rep', 'Employee'),
                ],
            )
            self.csv_to_object(
                'data/invoices.csv',
                'Invoice',
                [
                    'id',
                    ('customer', 'Customer'),
                    'datetime',
                    'str',
                    'str',
                    'str',
                    'str',
                    'str',
                    'decimal',
                ],
            )
            self.csv_to_object(
                'data/playlists.csv',
                'Playlist',
                [
                    'id',
                    'str',
                ],
            )
            self.csv_to_link(
                'data/playlist_track.csv',
                'Playlist',
                'tracks',
                'Track',
                ['source_id', 'target_id']
            )
            self.csv_to_link(
                'data/invoice_items.csv',
                'Invoice',
                'items',
                'Track',
                ['id', 'source_id', 'target_id', 'decimal', 'int64']
            )

        finally:
            with open('data/id_mappings.json', 'w') as f:
                f.write(json.dumps(self.id_mappings))

            self.client.close()

    def csv_to_object(self, file_name, object_name, types):
        with open(file_name, newline='') as csvfile:
            row_reader = csv.reader(csvfile, delimiter=',', quotechar='"')

            header = next(row_reader)

            fields = []
            for name, typ in zip(header, types):
                if typ == 'id':
                    continue
                if isinstance(typ, tuple):
                    (name, target_obj) = typ
                    fields.append(f'{name} := <{target_obj}><optional uuid>${name}')
                else:
                    fields.append(f'{name} := <{typ}><str>${name}')
            fields = ', '.join(fields)
            query = f'''
                SELECT (INSERT {object_name} {'{'}{fields}{'}'}).id
            '''

            if object_name not in self.id_mappings:
                self.id_mappings[object_name] = {}
            for row in row_reader:
                row_id = None

                field_values = {}
                for name, value, typ in zip(header, row, types):
                    if typ == 'id':
                        row_id = value
                        continue
                    if isinstance(typ, tuple):
                        (name, target_obj) = typ
                        if value not in self.id_mappings[target_obj]:
                            print(f'Missing key for {object_name}.{name}')
                            value = None
                        else:
                            value = uuid.UUID(self.id_mappings[target_obj][value])

                    field_values[name] = value

                if row_id in self.id_mappings[object_name]:
                    continue

                object_id = self.client.query_single(query, **field_values)

                self.id_mappings[object_name][row_id] = str(object_id)
                print(object_name, row_id, object_id)

    def csv_to_link(self, file_name, source, link, target, types):
        with open(file_name, newline='') as csvfile:
            row_reader = csv.reader(csvfile, delimiter=',', quotechar='"')

            header = next(row_reader)

            fields = []
            for name, typ in zip(header, types):
                if typ == 'id':
                    continue
                if typ == 'source_id' or typ == 'target_id':
                    continue

                fields.append(f'@{name} := <{typ}><str>${name}')
            fields = ', '.join(fields)
            query = f'''
                update {source}
                filter .id = <uuid>$source_id
                set {'{'}
                    {link} += (
                        select {target} {'{'}{fields}{'}'}
                        filter .id = <uuid>$target_id
                    )
                {'}'};
            '''

            for row in row_reader:

                row_id = None
                field_values = {}
                for name, value, ty in zip(header, row, types):
                    if ty == 'id':
                        row_id = value
                        continue
                    if ty == 'source_id':
                        name = 'source_id'
                        value = self.id_mappings[source][value]
                    elif ty == 'target_id':
                        name = 'target_id'
                        value = self.id_mappings[target][value]
                    
                    field_values[name] = value

                self.client.query_single(query, **field_values)

                print(f'{source}.{link} {row_id} {field_values["source_id"]} {field_values["target_id"]}')


if __name__ == '__main__':
    Seeder().seed()
