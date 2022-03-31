# Chef-Tutorial

Repository mit dem Quellcode für das Chef-Tutorial.

## 1. Aufgabe

Implementiere ein Chef Kochbuch mit dem Namen `welcome_message`, der [Message of the Day](https://de.wikipedia.org/wiki/Message_of_the_Day) definiert. Zu dem Kochbuch gibt es zwei Anforderungen.

1. Die `/etc/motd` Datei soll aus einem Embedded Ruby (ERB) Template gerendert werden.
2. Der Text, der in der Nachricht steht, soll konfigurierbar sein.

### Wei funktioniert das?

1.
    Wir können die Ordner-Struktur manuell anlegen. Wir können aber auch hierfür Chefs [Command-Line-Tool](https://docs.chef.io/workstation/ctl_chef/) verwenden.

    ````shell
    $ chef generate repo chef-tutorial
    ````

    Nachdem wir die Kommandozeile ausgeführt haben, müssen wir das Verzeichnis aufräumen. Für das Tutorial brauchen wir nicht alles, was von der CLI angelegt wurde.

    ````shell
    $ tree chef-tutorial
    chef-tutorial/
    ├── cookbooks
    │   └── welcome_message
    │       ├── attributes
    │       │   └── default.rb
    │       ├── recipes
    │       │   └── default.rb
    │       ├── templates
    │       │   └── motd.erb
    │       └── metadata.rb
    ````

2.
    Fürs Rendern und anschließend Anlegen einer Datei auf dem Host gibt es eine entsprechende Ressource von Chef. Diese heißt [template](https://docs.chef.io/resources/template/). Hier ist ein Beispiel.

    ````ruby
    template '/etc/motd' do
        source 'motd.erb'
        owner 'root'
        group 'root'
        mode '0664'
    end
    ````

3.
    Damit der Inhalt der Datei parametrierbar ist, können wir hier Variablen einsetzen, sogenannte [Attribute](https://docs.chef.io/recipes/#recipe-attributes). Diese werden im Ordner `attributes` definiert. Hier ist ein Beispiel.

    ````ruby
    default['python']['version'] = '3.8'
    ````

    Die Attribute kann man dann später z.b. in dem Template einsetzen.

    ````erb
    python Version: <%= node['python']['version'] %>
    ````

    Aber auch im Kochbuch selbst.

    ````ruby
    yum_package 'python3' do
        version node['python']['version']
        action :install
    end
    ````

## 2. Aufgabe

Starte eine Vagrant-Box und führe das Kochbuch aus.

### Wei funktioniert das?

1.
    Vagrant unterstützt [Chef Solo Provider](https://www.vagrantup.com/docs/provisioning/chef_solo). Damit lassen sich die Rezepte auf der VM ausführen. Die Konfiguration für Vagrant wird in einem Vagrantfile geschrieben.

2.
    Die Box lässt sich über die Kommandozeile steuern. Dafür gibt es folgende Befehle.

    Vagrant-Box starten

    ````shell
    $ vagrant up
    ````

    Vagrant-Box neu provisionieren

    ````shell
    $ vagrant provision
    ````

    Vagrant-Box stoppen

    ````shell
    $ vagrant halt
    ````

    Vagrant-Box löschen

    ````shell
    $ vagrant destroy
    ````

## 3. Aufgabe

Implementiere die Integration-Tests für das Kochbuch.

### Wei funktioniert das?

1.
    Die Integration-Tests lassen sich mit [Test Kitchen](https://docs.chef.io/workstation/kitchen/) implementieren. Hier für braucht man zwei Sachen, Kitchen-Konfiguration (`.kitchen.yml`) und die Tests selbst.

    In der Konfiguration definiert man, welchen Hypervisor man verwenden will, auf welchem Betriebssystem das Kochbuch installiert werden soll und wo die Tests liegen.

    Die Tests werden mit [InSpec](https://docs.chef.io/inspec/) beschrieben. InSpec bietet von Haus aus mehrere Ressourcen an, die man verwenden kann. Zum Beispiel [File](https://docs.chef.io/inspec/resources/file/) für Tests rund um Dateien.

    `````yaml
    ---
    driver:
        name: vagrant

    provisioner:
        name: chef_zero
        always_update_cookbooks: true

    verifier:
        name: inspec

    platforms:
        - name: ubuntu-20.04
        - name: centos-8

    suites:
        - name: default
            run_list:
                - recipe[cookbook::default]
    `````

2.
    Die Tests lassen sich mit folgendem Befehl ausführen.

    ````shell
    $ kitchen test
    ````

## 4. Aufgabe

Implementiere die Unit-Tests für das Kochbuch.

### Wei funktioniert das?

1.
    Die Unit-Tests werden mit [ChefSpec](https://docs.chef.io/workstation/chefspec/) beschrieben.

    ````ruby
    require 'chefspec'

    describe 'cookbook::default' do
        context 'Unit testing on Ubuntu 20.04' do
            platform 'ubuntu', '20.04'

            it 'converges successfully' do
                expect { chef_run }.to_not raise_error
            end
        end
    end
    ````

2.
    Die Tests lassen sich mit folgendem Befehl ausführen.

    ````shell
    $ rspec cookbooks/welcome_message/spec/unit
    ````
