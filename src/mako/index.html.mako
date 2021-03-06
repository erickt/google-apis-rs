<%
    import os
    import yaml
    from util import (gen_crate_dir, api_index, crates_io_url, program_name, program_download_url)

    title = 'Google Service Documentation for Rust'

    # type cache: {'api': type-api.yaml-contents }
    tc = dict()
    for api_type in make.types:
        data = yaml.load_all(open(os.path.join(directories.api_base, 'type-%s.yaml' % api_type)))
        tc[api_type] = type(directories)(data.next())
    # end for each type to load cache for
%>\
<!DOCTYPE html>
<!--
DO NOT EDIT !
This file was generated automatically by '${self.uri}'
DO NOT EDIT !
-->
<html>
<head>
<link rel="stylesheet" href="main.css">
<style type="text/css">
.text {
  color: #000000;
  font-size: 20px
}
.mod {
  color: #4d76ae;
  font-size: 20px
}
</style>
	<title>${title}</title>
</head>
<body>
<H1>${title}</H1>
<ul>
% for an in sorted(api.list.keys()):
    % for v in api.list[an]:
        <% 
            has_any_index = False
            type_names = list()
            for program_type, ad in tc.iteritems():
                if api_index(DOC_ROOT, an, v, ad.make):
                    has_any_index = True
                    type_names.append(program_type)
            # end for each type
        %>\
        % if not has_any_index:
            <% continue %>\
        % endif
        <span class="text">${an} ${v} (
        % for program_type in type_names:
            <% ad = tc[program_type] %>
            <a class="mod" href="${api_index(DOC_ROOT, an, v, ad.make)}" title="${ad.make.id.upper()} docs for the ${an} ${v}">${ad.make.id.upper()}</a>
            % if program_type == 'api':
            <a href="${crates_io_url(an, v)}"><img src="${url_info.asset_urls.crates_img}" title="This API on crates.io" height="16" width="16"/></a>
            % else:
            % for os_name in make.platforms:
            <a href="${program_download_url(url_info.download_base_url, program_type, ad.cargo.build_version, os_name, an, v)}"><img src="${url_info.asset_urls.get('%s_img' % os_name)}" title="Download the pre-compiled 64bit program for ${os_name}" height="16" width="16"/></a>
            % endfor ## each os
            % endif
            % if not loop.last:
,           
            % endif
        % endfor # each program type
        )</span><br/>
    % endfor # each version
% endfor # each API
</ul>
</body>
</html>