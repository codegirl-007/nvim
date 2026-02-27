return {
  'ThePrimeagen/99',
  dir = '/Users/stephaniegredell/projects/99',
  dev = true,
  config = function()
    local ok, _99 = pcall(require, '99')
    if not ok then
      vim.notify('Failed to load 99: ' .. tostring(_99), vim.log.levels.ERROR)
      return
    end

    -- Setup with basic config
    local setup_ok, setup_err = pcall(function()
      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)

      _99.setup {
        provider = _99.Providers.OpenCodeProvider,
        logger = {
          level = _99.DEBUG,
          path = '/tmp/' .. basename .. '.99.debug',
          print_on_error = true,
        },
        tmp_dir = './tmp',
        completion = {
          source = 'native',
          custom_rules = {
            'scratch/custom_rules/',
          },
          files = {
            enabled = true,
            max_file_size = 100 * 1024,
            max_files = 5000,
            exclude = { '.env', '.env.*', 'node_modules', '.git', 'dist', 'build', '*.log', '.DS_Store' },
          },
        },
        md_files = { 'AGENT.md' },
      }
    end)

    if not setup_ok then
      vim.notify('99 setup failed: ' .. tostring(setup_err), vim.log.levels.ERROR)
      return
    end

    -- Keymaps (matching README suggestions)
    vim.keymap.set('v', '<leader>9v', function()
      local ok, err = pcall(_99.visual)
      if not ok then
        vim.notify('99 visual error: ' .. tostring(err), vim.log.levels.ERROR)
      end
    end, { desc = '99: Visual selection' })

    vim.keymap.set('n', '<leader>9x', function()
      _99.stop_all_requests()
    end, { desc = '99: Cancel all requests' })

    vim.keymap.set('n', '<leader>9s', function()
      local ok, err = pcall(_99.search)
      if not ok then
        vim.notify('99 search error: ' .. tostring(err), vim.log.levels.ERROR)
      end
    end, { desc = '99: Search prompt' })

    vim.keymap.set('n', '<leader>9m', function()
      require('99.extensions.telescope').select_model()
    end, { desc = '99: Select model' })

    vim.keymap.set('n', '<leader>9p', function()
      require('99.extensions.telescope').select_provider()
    end, { desc = '99: Select provider' })

    vim.notify('99 plugin loaded successfully', vim.log.levels.INFO)
  end,
}
