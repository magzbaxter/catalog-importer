{
  // Unique identifier for this importer configuration
  sync_id: 'your-company/backstage-migration',

  pipelines: [
    {
      // Sources - where to pull catalog data from
      sources: [
        {
          backstage: {
            // Your Backstage API endpoint
            endpoint: 'https://backstage.your-company.com/api/catalog/entities/by-query',
            
            // Multi-header authentication for setups requiring both
            // Authorization and Cookie headers
            headers: {
              'Authorization': 'Bearer $(BACKSTAGE_TOKEN)',
              'Cookie': '$(COOKIE_VALUE)',
            },
            
            // Optional: Filter entities if needed
            // filter: 'kind=Component,metadata.namespace=default',
            
            // Optional: Customize page size
            // page_size: 50,
          },
        },
      ],

      // Outputs - how to structure data in incident.io catalog
      outputs: [
        // Example: Import Backstage Components as Services
        {
          name: 'Service',
          description: 'Services imported from Backstage',
          categories: ['service'],
          type_name: 'Custom["Service"]',
          
          source: {
            // Only import Components from Backstage
            filter: '$.kind == "Component"',
            external_id: '$.metadata.name',
            name: '$.metadata.name',
          },
          
          attributes: [
            {
              id: 'description',
              name: 'Description', 
              type: 'Text',
              source: '$.metadata.description',
            },
            {
              id: 'owner',
              name: 'Owner',
              type: 'String',
              source: '$.spec.owner',
            },
            {
              id: 'lifecycle',
              name: 'Lifecycle',
              type: 'String', 
              source: '$.spec.lifecycle',
            },
            {
              id: 'system',
              name: 'System',
              type: 'String',
              source: '$.spec.system',
            },
          ],
        },
        
        // Example: Import Backstage Users as Users
        {
          name: 'User',
          description: 'Users imported from Backstage',
          categories: ['user'],
          type_name: 'Custom["User"]',
          
          source: {
            // Only import Users from Backstage
            filter: '$.kind == "User"', 
            external_id: '$.metadata.name',
            name: '$.spec.profile.displayName || $.metadata.name',
          },
          
          attributes: [
            {
              id: 'email',
              name: 'Email',
              type: 'String',
              source: '$.spec.profile.email',
            },
            {
              id: 'title',
              name: 'Title', 
              type: 'String',
              source: '$.spec.profile.title',
            },
          ],
        },
        
        // Example: Import Backstage Groups as Teams
        {
          name: 'Team',
          description: 'Teams imported from Backstage',
          categories: ['team'],
          type_name: 'Custom["Team"]',
          
          source: {
            // Only import Groups from Backstage
            filter: '$.kind == "Group"',
            external_id: '$.metadata.name', 
            name: '$.spec.profile.displayName || $.metadata.name',
          },
          
          attributes: [
            {
              id: 'description',
              name: 'Description',
              type: 'Text',
              source: '$.metadata.description',
            },
            {
              id: 'type',
              name: 'Type',
              type: 'String',
              source: '$.spec.type',
            },
            {
              id: 'parent',
              name: 'Parent Team',
              type: 'String',
              source: '$.spec.parent',
            },
          ],
        },
      ],
    },
  ],
}