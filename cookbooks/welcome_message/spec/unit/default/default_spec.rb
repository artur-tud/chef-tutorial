require 'chefspec'

describe 'welcome_message::default' do
    context 'When all attributes are default, on Ubuntu 20.04' do
        # for a complete list of available platforms and versions see:
        # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
        platform 'ubuntu', '20.04'

        it 'converges successfully' do
            expect { chef_run }.to_not raise_error
        end

        it 'renders motd.erb' do
            expect(chef_run).to render_file('/etc/motd').with_content('Hello!') 
        end
    end
end
